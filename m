From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH RESEND 1/2] lvm2: 69-dm-lvm-metad.rules:
 explicit pvscan rule
Date: Tue, 17 Apr 2018 11:46:43 +0200
Message-ID: <8adb2a0c-3aa2-2233-0ba7-40e95cc602a5@redhat.com>
References: <20180416185341.8588-1-mwilck@suse.com>
	<20180416185341.8588-2-mwilck@suse.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
In-Reply-To: <20180416185341.8588-2-mwilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, lvm-devel@redhat.com, Hannes Reinecke <hare@suse.de>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On 04/16/2018 08:53 PM, Martin Wilck wrote:
> Make the distinction between the cases with and without systemd
> background jobs explicit in 69-dm-lvm-metad.rules rather than
> substituting the rule from the Makefile. At this stage,
> this improves only readibility, at the cost of one GOTO statement.
> 
> The next patch will add more differences between the two cases (mostly
> comments), which are practically impossible to generate with the current
> string subsitution approach.
> 
> This patch introduces no functional change to the udev rules.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  udev/69-dm-lvm-metad.rules.in | 19 ++++++++++++++++++-
>  udev/Makefile.in              |  7 ++++---
>  2 files changed, 22 insertions(+), 4 deletions(-)
> 

OK, I agree, this makes it a bit more readable, applied:

https://sourceware.org/git/?p=lvm2.git;a=commit;h=99bfbbf229acf4548f1ffc06625f464dc0ae4ca4

Thanks

-- 
Peter

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
