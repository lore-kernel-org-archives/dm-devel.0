From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: several small issues
Date: Sat, 09 Jul 2005 15:02:42 +0200
Message-ID: <1120914162.26998.36.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AB4E@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AB4E@SRMANNING.eng.emc.com>
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

On ven, 2005-07-08 at 00:09 -0400, goggin, edward wrote:
> Christophe,
> 
> (1) Could you initialize di_flag to 0 in main() of multipath/main.c or
> else "multipath -l" and "multipath -ll" use a non-deterministic flags
> value for path discovery?
> 
done

> (2) Could you append a "\n" to the logging string in the call to condlog()
> from
> get_word() in libmultipath/util.c?  Doing so helps the readability of the
> event
> log when starting multipathd with "-v4".
> 
May be I should just comment this log now that this code path is stable.
Anyway, I don't really see the readability problem you mention ...

> (3) Could you change checkerloop() in multipathd/main.c to call LOG_MSG
> with the checker message if the path state is failed?  This would be useful
> for administrators and it also helps our debugging -- it helps point out
> cases
> where multipathd may think a path's checker state is failed even when
> "multipath -l" shows otherwise.
> 
done, only for '-v4', and whatever the check return value.

> (4) The multipathd is dying when I send it a "show paths" or "display paths"
> message.  I haven't debugged it to know what's wrong.
> 
Not for me, so I'll let you dig this one ...

xa-s05:~/scm/test# multipathd/multipathd -k"show paths"

       sdb: state 2,  12/ 14 XXXXXXXXXXXX..
       sdc: state 2,  12/ 14 XXXXXXXXXXXX..
       sdd: state 2,  12/ 14 XXXXXXXXXXXX..
       sde: state 2,  12/ 14 XXXXXXXXXXXX..
       sdf: state 2,  12/ 14 XXXXXXXXXXXX..
       sdg: state 2,  12/ 14 XXXXXXXXXXXX..
       sdh: state 2,  12/ 14 XXXXXXXXXXXX..
       sdi: state 2,  12/ 14 XXXXXXXXXXXX..
       sdj: state 2,  12/ 14 XXXXXXXXXXXX..
       sdk: state 2,  12/ 14 XXXXXXXXXXXX..
       sdl: state 2,  12/ 14 XXXXXXXXXXXX..
       sdm: state 2,  12/ 14 XXXXXXXXXXXX..

xa-s05:~/scm/test# multipathd/multipathd -k"display paths"
 list|show paths
 list|show maps
 add path $path
 remove|del path $path
 add map $map
 remove|del map $map
 switch|switchgroup map $map group $group

xa-s05:~/scm/test# pgrep multipathd
18462
xa-s05:~/scm/test#


Thanks for the feedback,
-- 
christophe varoqui <christophe.varoqui@free.fr>
