From: "goggin, edward" <egoggin@emc.com>
Subject: Re: multipathd can fail to monitor paths in some corne
	r cases
Date: Thu, 7 Jul 2005 19:23:27 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB48@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 01 Jul 2005 23:48:21 +0200
christophe varoqui <christophe.varoqui@free.fr> wrote

> Would you adhere to this variant ?
>
> ... because :
>
> 1) disass*table is always called before disass*status
> 2) saves a couple of loops
>
> Anyway, did you solve your git problems ?
> Your testing would be much appreciated on HEAD.

I'm able to at least check out the git head -- haven't
tried updating it yet though.

I tested your code on the git head and it works well.

I ran into other issues (mostly SuSE kernel) which is
why its taken me so long to validate.  Sorry!

What about also handling paths which are attached to the
kernel (already scanned by LLDD) but not usable when multipath(8) is
run but which could be detected to be usable by multipath?
This would involve multipathd determining a path's UID and
trying to match it with any known multipath map.  If it
didn't find one it could create and populate it -- effectively
doing the discovery process done by multipath(8).

Would require a library interface to the getuid functions like
scsi_id.  May be too much investment for little return though :((

Ed
