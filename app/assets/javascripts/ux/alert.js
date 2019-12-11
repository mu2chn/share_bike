//need to make div

function makeAlert(div, msg, type="info") {
    div.insertAdjacentHTML('afterend', `
      <div class="alert alert-${type}" role="alert">
        <div class="container">
          <div class="alert-icon">
            <i class="now-ui-icons ui-2_like"></i>
          </div>
          <strong>${type}</strong> ${msg}
             <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">
                 <i class="now-ui-icons ui-1_simple-remove"></i>
                </span>
            </button>
        </div>
      </div>
    `)
}