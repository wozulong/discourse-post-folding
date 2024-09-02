import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { apiInitializer } from "discourse/lib/api";
// import I18n from "I18n";

// const pluginId = "discourse-post-folding";

export default apiInitializer("1.16.0", (api) => {
  // api.modifyClass(
  //   "controller:topic",
  //   (Superclass) =>
  //     class extends Superclass {
  //       subscribe() {
  //         super.subscribe(...arguments);
  //         console.log(
  //           "subscribe",
  //           `/discourse-post-folding/topic/${this.model.id}`
  //         );
  //         this.messageBus.subscribe(
  //           `/discourse-post-folding/topic/${this.model.id}`,
  //           this._onPostFoldingMessage
  //         );
  //       }
  //       unsubscribe() {
  //         this.messageBus.unsubscribe(
  //           "/discourse-post-folding/topic/*",
  //           this._onPostFoldingMessage
  //         );
  //         super.unsubscribe(...arguments);
  //       }
  //       _onPostFoldingMessage(msg) {
  //         console.log(msg);
  //         const post = this.get("model.postStream").findLoadedPost(msg.post_id);
  //         post?.set("post_folding_status", msg.post_folding_status);
  //       }
  //     }
  // );

  api.includePostAttributes("post_folding_status");

  api.addPostClassesCallback((attrs) => {
    if (attrs.post_folding_status == null) {
      return [];
    } else {
      return ["folded"];
    }
  });

  api.addPostAdminMenuButton((attrs) => {
    const currentUser = api.getCurrentUser();

    if (attrs.post_number === 1) {
      return;
    }

    if (!currentUser?.can_fold_post) {
      return;
    }

    const folded = attrs.post_folding_status != null;

    return {
      action: (post) => {
        ajax(`/discourse-post-folding/status/${post.id}`, {
          type: folded ? "DELETE" : "PUT",
          data: {},
        })
          .then((res) => {
            post.set("post_folding_status", res.post_folding_status);
            api.container
              .lookup("service:app-events")
              .trigger("post-stream:refresh", {
                id: post.id,
              });
          })
          .catch(popupAjaxError);
      },
      icon: folded ? "expand" : "compress",
      className: "discourse_post_folding-fold-btn",
      label: folded
        ? "discourse_post_folding.expand.title"
        : "discourse_post_folding.fold.title",
    };
  });
});
