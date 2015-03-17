From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] dm-verity: Add error handling modes for
 corrupted blocks
Date: Tue, 17 Mar 2015 11:27:49 -0400
Message-ID: <20150317152749.GA24901@redhat.com>
References: <20150316155559.GA32397@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150316155559.GA32397@google.com>
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
Cc: wad@chromium.org, msb@chromium.org, mpatocka@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 16, 2015 at 03:55:59PM +0000, Sami Tolvanen wrote:
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

What's the idea behind kernel restart mode ? If a corrupted block is in
the path of boot, will we not get into a continuous reboot cycle.

Thanks
Vivek
