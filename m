From: "goggin, edward" <egoggin@emc.com>
Subject: How about having multipathd re-enable a currently
	disabled (bypas sed) path group ...
Date: Fri, 10 Jun 2005 12:50:44 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AA8F@SRMANNING.eng.emc.com>
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

... whenever any path in the path group tests successfully, that is,
the path checker for the path returns PATH_UP (that is, not
PATH_DOWN, PATH_SHAKY, or -1)?

It is architecturally asymmetrical to push this responsibility up to SAN
management applications and/or administrators (as it currently stands) 
since the path group can be put into a disabled mode by either user or
kernel
multipath code without any action explicitly involving disabling path groups
on behalf of the administrator.
