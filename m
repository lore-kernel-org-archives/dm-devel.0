From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 03/18] Export outsz() and outhnt() for modules
Date: Mon, 2 Nov 2009 14:54:20 +0000
Message-ID: <20091102145420.GE13375@agk-dp.fab.redhat.com>
References: <1257171622-8380-1-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-2-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-3-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-4-git-send-email-zkabelac@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1257171622-8380-4-git-send-email-zkabelac@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 02, 2009 at 03:20:07PM +0100, Zdenek Kabelac wrote:
> Adding macro outsz() for out_size() and outhnt() for out_hint()
> that checks for error in a similar way as outf() does for out_text()
 
Ack.

outhint rather than outhnt perhaps?

Alasdair
