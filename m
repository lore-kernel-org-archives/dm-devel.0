From: "goggin, edward" <egoggin@emc.com>
Subject: RE: path priority
Date: Wed, 3 Aug 2005 12:19:28 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ABA8@SRMANNING.eng.emc.com>
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

On Tue, 02 Aug 2005 22:27:09 +0200
christophe varoqui <christophe.varoqui@free.fr> wrote

> Yes, also note "group_by_priority" path grouping policy may 
> be overkill
> for the context. PG produced by "group_by_serial" can be 
> sorted with an
> adequate prioritizer too.

Yeah, I forgot about the fact that the get_priority callout
can be used to determine the highest priority path group to
use for all of the path grouping policies ... not just the
group_by_priority one.
