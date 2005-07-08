From: "goggin, edward" <egoggin@emc.com>
Subject: several small issues
Date: Fri, 8 Jul 2005 00:09:37 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB4E@SRMANNING.eng.emc.com>
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
Cc: christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Christophe,

(1) Could you initialize di_flag to 0 in main() of multipath/main.c or
else "multipath -l" and "multipath -ll" use a non-deterministic flags
value for path discovery?

(2) Could you append a "\n" to the logging string in the call to condlog()
from
get_word() in libmultipath/util.c?  Doing so helps the readability of the
event
log when starting multipathd with "-v4".

(3) Could you change checkerloop() in multipathd/main.c to call LOG_MSG
with the checker message if the path state is failed?  This would be useful
for administrators and it also helps our debugging -- it helps point out
cases
where multipathd may think a path's checker state is failed even when
"multipath -l" shows otherwise.

(4) The multipathd is dying when I send it a "show paths" or "display paths"
message.  I haven't debugged it to know what's wrong.

Ed
