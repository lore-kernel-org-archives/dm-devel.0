From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCHv3] dm-verity: Add error handling modes for
 corrupted blocks
Date: Thu, 19 Mar 2015 18:18:21 -0400
Message-ID: <CAMM=eLdOo8FzmdY6ubYTzjk1pW1FfVUtTdjFsNwEL2qX04vuJw@mail.gmail.com>
References: <20150316155559.GA32397@google.com>
	<20150318155214.GB29369@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150318155214.GB29369@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: wad@chromium.org, msb@chromium.org, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Wed, Mar 18, 2015 at 11:52 AM, Sami Tolvanen <samitolvanen@google.com> wrote:
> Add device specific modes to dm-verity to specify how corrupted
> blocks should be handled. The following modes are defined:
>
>   - DM_VERITY_MODE_EIO is the default behavior, where reading a
>     corrupted block results in -EIO.
>
>   - DM_VERITY_MODE_LOGGING only logs corrupted blocks, but does
>     not block the read.
>
>   - DM_VERITY_MODE_RESTART calls kernel_restart when a corrupted
>     block is discovered.
>
> In addition, each mode sends a uevent to notify userspace of
> corruption and to allow further recovery actions.
>
> The driver defaults to previous behavior (DM_VERITY_MODE_EIO)
> and other modes can be enabled with an additional parameter to
> the verity table.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

I staged this v3 with a few additional fixes (mainly whitespace and
nits) but I did need to export dm_disk() otherwise building dm-verity
as a module would fail.

See:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=cf987c1bc5d4c7c6aeed3648118eaa008c1abf8d
