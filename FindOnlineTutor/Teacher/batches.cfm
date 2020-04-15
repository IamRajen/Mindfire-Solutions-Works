<!---
Project Name: FindOnlineTutor.
File Name: batches.cfm.
Created In: 15th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a batch page which contains all the related information for a teacher
--->
<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css">

<h1 class="d-inline text-info">Batches</h1>
<button type="button" class="btn btn-outline-info float-right" data-toggle="modal" data-target="#addNewBatch">
    Add new Batch
</button>
<hr>

<!-- The Modal -->
  <div class="modal fade" id="addNewBatch">
    <div class="modal-dialog">
      <div class="modal-content">
      
        <!-- Modal Header -->
        <div class="modal-header">
          <h4 class="modal-title pl-5">Batch Information</h4>
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        
        <!-- Modal body -->
        <div class="modal-body">
          
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
        </div>
        
      </div>
    </div>
  </div>
 

</cf_header>