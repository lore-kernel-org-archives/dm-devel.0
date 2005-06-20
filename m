From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: an unintentionally blacklisted LU and a multipathd
	SIGSEGV in 0.4 .5-pre3
Date: Mon, 20 Jun 2005 17:18:19 +0200
Message-ID: <20050620151819.GA7446@averon.dyndns.org>
References: <C2EEB4E538D3DC48BF57F391F422779321AAD3@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AAD3@SRMANNING.eng.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 20, 2005 at 10:58:35AM -0400, goggin, edward wrote:
> First, an LU with a scsi_id assigned UID of
> 36006016087711200afd8d0905137d911
> was being blacklisted because the default blacklist includes a regular
> expression
> of the form "(ram | raw | loop | fd)[0-9]*" which happens to match the
> substring "fd8"

merged, thanks.

> 
> Second, the multipathd in version 0.4.5-pre3 of multipath-tools will SIGSEGV
> whenever it dereferences a null mpp field of a path struct in checkerloop().
> This
> field will be null at least in cases where the path is either blacklisted or
> its UID
> cannot be determined.
> 
Yes I merged another fix for that earlier today.
I chose a less radical approach, by checking pp->mpp before using it.
Do you care ?

Regards,
cvaroqui
