<div class="card card-body mt-3 rest-part">
    <div>
        <h3 class="mb-1">{{ translate('Product_Video') }}</h3>
        <p class="fs-12 mb-3">
            {{ translate('Choose to upload a video file or paste a YouTube embed link.') }}
        </p>
    </div>
    <div class="bg-section rounded-10 p-12 p-sm-20">
        <div class="d-flex gap-4 align-items-center mb-3">
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="video_option" id="video_option_upload" value="upload" checked>
                <label class="form-check-label fw-semibold" for="video_option_upload">
                    {{ translate('Upload_Video_File') }} <span class="text-info">({{ translate('Max_20MB,_1_Min') }})</span>
                </label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="video_option" id="video_option_link" value="link">
                <label class="form-check-label fw-semibold" for="video_option_link">
                    {{ translate('Paste_YouTube_Link') }}
                </label>
            </div>
        </div>

        <!-- File Upload Section -->
        <div id="video_upload_section">
            <div class="mb-3">
                <label class="form-label mb-0">
                    {{ translate('Choose_Video_File') }}
                </label>
                <span> ({{ translate('optional') }})</span>
            </div>
            <div class="custom-file text-left">
                <!-- File input will be submitted directly with the form -->
                <input type="file" name="product_video" id="product_video_input" class="custom-file-input" accept=".mp4,.webm,.mov,.avi,.mkv" data-max-size="20">
                <label class="custom-file-label" for="product_video_input">{{ translate('choose_file') }}</label>
            </div>
            
            <small class="form-text text-muted mt-2 d-block">
                {{ translate('Supported formats: MP4, WebM. Maximum size: 20MB. Maximum duration: 60 seconds (1 minute). File will be uploaded directly to YouTube during product save.') }}
            </small>
        </div>

        <!-- Pasted Link Section -->
        <div id="video_link_section" class="d-none">
            <div class="mb-3">
                <label class="form-label mb-0">
                    {{ translate('youtube_video_link') }}
                </label>
                <span> ({{ translate('optional') }})</span>
            </div>
            <input type="text" id="video_url_input"
                   placeholder="{{ translate('ex').': https://www.youtube.com/embed/5R06LRdUCSE' }}"
                   class="form-control">
            <p class="mt-1 mb-0 fs-12 text-muted">{{ translate('please_provide_embed_link_not_direct_link.') }}</p>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const optionUpload = document.getElementById('video_option_upload');
        const optionLink = document.getElementById('video_option_link');
        const uploadSection = document.getElementById('video_upload_section');
        const linkSection = document.getElementById('video_link_section');
        const videoInput = document.getElementById('product_video_input');
        const urlInput = document.getElementById('video_url_input');

        function toggleSections() {
            if (optionUpload.checked) {
                uploadSection.classList.remove('d-none');
                linkSection.classList.add('d-none');
                urlInput.name = ''; // Clear text input name to prevent conflict
                videoInput.name = 'product_video'; // Restore file input name
            } else {
                uploadSection.classList.add('d-none');
                linkSection.classList.remove('d-none');
                urlInput.name = 'video_url'; // Set text input name
                videoInput.name = ''; // Clear file input name to prevent uploading empty files
                videoInput.value = '';
                videoInput.nextElementSibling.innerText = "{{ translate('choose_file') }}";
            }
        }

        optionUpload.addEventListener('change', toggleSections);
        optionLink.addEventListener('change', toggleSections);
        toggleSections(); // Run initially to align input names

        // Frontend validation helper for selecting file (limits size/duration)
        videoInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (!file) return;

            // Validate video size is <= 20MB
            const maxSizeInBytes = 20 * 1024 * 1024;
            if (file.size > maxSizeInBytes) {
                toastr.error("{{ translate('Video file size exceeds 20MB! Please select a smaller file.') }}", {
                    CloseButton: true,
                    ProgressBar: true
                });
                this.value = '';
                this.nextElementSibling.innerText = "{{ translate('choose_file') }}";
                return;
            }

            // Show filename in custom input label
            this.nextElementSibling.innerText = file.name;

            // Validate video duration is <= 60 seconds
            const video = document.createElement('video');
            video.preload = 'metadata';
            video.onloadedmetadata = function() {
                window.URL.revokeObjectURL(video.src);
                if (video.duration > 60) {
                    toastr.error("{{ translate('Video duration exceeds 1 minute! Please select a shorter video.') }}", {
                        CloseButton: true,
                        ProgressBar: true
                    });
                    videoInput.value = '';
                    videoInput.nextElementSibling.innerText = "{{ translate('choose_file') }}";
                }
            }
            video.src = URL.createObjectURL(file);
        });
    });
</script>
