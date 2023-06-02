

$(function () {

  const filterButtons = document.querySelectorAll('.filter-button');

  // Loop through each filter button
  filterButtons.forEach(function (button) {
    // Add a click event listener to the button
    button.addEventListener('click', function () {
      // Get the filter value for this button
      const filterValue = button.getAttribute('data-filter');

      // Get all table rows
      const tableRows = document.querySelectorAll('#items-table-body tr');

      // Loop through each row and show/hide based on the filter value
      tableRows.forEach(function (row) {
        const enviadoTd = row.querySelector('.enviado');

        if (filterValue === 'all') {
          row.style.display = '';
        } else if (filterValue === 'enviado') {
          if (enviadoTd && enviadoTd.textContent.trim() === 'Sim') {
            row.style.display = '';
          } else {
            row.style.display = 'none';
          }
        } else if (filterValue === 'nao-enviado') {
          if (enviadoTd && enviadoTd.textContent.trim() === 'Nao') {
            row.style.display = '';
          } else {
            row.style.display = 'none';
          }
        }
      });
    });
  });

  /*
    document.querySelector(".th").click(function () {
      if (fv == 'all') document.querySelectorAll('.filter-button[data-filter="all"]').forEach(function (bt) { bt.click(); });
      else if (fv == 'enviado') document.querySelectorAll('.filter-button[data-filter="enviado"]').forEach(function (bt) { bt.click(); });
      else if (fv == 'nao-enviado') document.querySelectorAll('.filter-button[data-filter="nao-enviado"]').forEach(function (bt) { bt.click(); });
    })
  
  */


});