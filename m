From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Temporarily squelching multipathd errors
Date: Sat, 19 Jul 2008 10:27:50 +0200
Message-ID: <1216456070.7364.4.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: daniel.keisling@austin.ppdi.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


> Greetings,
>  
> I perform SAN-based snapshots on OCFS2 and ext3 filesystems under
> dm-multipath.  Before I snapshot the filesystem, I unmount and delete
> the previous night's snapshot LUNs.  Doing so causes (correctly)
> multipathd to output the following errors:
>  
> <snip>
> ...
> Jul 14 03:16:02 ausracdbd01 multipathd: mpath19: remaining active paths:
> 7
> Jul 14 03:16:02 ausracdbd01 multipathd: sdci: tur checker reports path
> is down
> Jul 14 03:16:02 ausracdbd01 kernel: device-mapper: multipath: Failing
> path 69:80.
> Jul 14 03:16:02 ausracdbd01 multipathd: sdco: tur checker reports path
> is down
> ....
> </snip>
>  
> During this snapshot time, I would like to temporarily turn off the
> verbosity of multipathd.  Is this possible?  It's mostly an annoyance
> factor for me because our nightly centralized syslog scan picks up words
> like 'fail' and generates a report to the system administrators (which
> we then have to ignore for these messages).
> 
Why not just remove the multipath from the multipathd topology before deleting the snapvol ?

multipathd -k"del map mpath19"

Regards,
cvaroqui
