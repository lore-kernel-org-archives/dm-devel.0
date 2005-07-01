From: "goggin, edward" <egoggin@emc.com>
Subject: thoughts about having device specific "multipath -l"
	display opti ons?
Date: Fri, 1 Jul 2005 17:45:29 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB3C@SRMANNING.eng.emc.com>
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

Any thoughts about this?

Would definitely like to know for EMC CLARiiON which one of the 2 possible
path groups is active and which one is the default owner for a particular
logical
unit -- since the current "multipath -l" display does not currently provide
this
information in an accurate fashion at all times.
