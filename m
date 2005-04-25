From: "goggin, edward" <egoggin@emc.com>
Subject: Should enhanced bio error state be propagated upwards to
	parent o f failed cloned bios?
Date: Mon, 25 Apr 2005 11:34:32 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A93A@SRMANNING.eng.emc.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Should the bi_error field of a failed bio clone completion be propagated
upwards into the parent of the cloned bio, possibly in dec_pending() of
dm.c?  Doing so will allow target drivers higher than the one managing
the bottom-most mapped device to have access to enhanced bio sense
and error information.  Otherwise, all they see is -EIO like now.
