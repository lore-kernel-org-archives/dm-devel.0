From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] dm_crypt: Issue all previous bios before
 remapping barrier bio
Date: Mon, 01 Feb 2010 16:39:42 +0100
Message-ID: <4B66F5BE.3030205@redhat.com>
References: <201002012049.27132.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201002012049.27132.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 02/01/2010 04:19 PM, Nikanth Karthikesan wrote:
> Before remapping a barrier bio, make sure that there are no un-issued
> pending I/O in the workqueue. Otherwise a dm_flush would simply add
> a barrier request to the underlying device, without issuing the bio's
> queued in the dm_crypt device.

This should not be needed. Core dm code waits for all bios submitted before
barrier requests.

Mikulas, could you verify it?

Milan
