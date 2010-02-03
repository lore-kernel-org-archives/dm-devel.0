From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH] dm_crypt: Issue all previous bios before
	remapping barrier bio
Date: Wed, 3 Feb 2010 11:39:15 +0530
Message-ID: <201002031139.15659.knikanth@suse.de>
References: <201002012049.27132.knikanth@suse.de> <4B66F5BE.3030205@redhat.com>
	<Pine.LNX.4.64.1002020743340.30625@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1002020743340.30625@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tuesday 02 February 2010 18:17:24 Mikulas Patocka wrote:
> On Mon, 1 Feb 2010, Milan Broz wrote:
> > On 02/01/2010 04:19 PM, Nikanth Karthikesan wrote:
> > > Before remapping a barrier bio, make sure that there are no un-issued
> > > pending I/O in the workqueue. Otherwise a dm_flush would simply add
> > > a barrier request to the underlying device, without issuing the bio's
> > > queued in the dm_crypt device.
> >
> > This should not be needed. Core dm code waits for all bios submitted
> > before barrier requests.
> >
> > Mikulas, could you verify it?
> >
> > Milan
> 
> Yes, you are right, the patch is not needed.
> 
> When the target receives an empty barrier request, there are no other data
> requests in flight.
> 
> BTW. The target may receive more empty barrier requests simultaneously, if
> it asked for it by setting ti->num_flush_requests to more than one. But
> barrier and non-barrier requests are never mixed.
> 

Correct. Sorry, I was a bit hasty in sending that patch. It is not required. 
Thanks for the patient explanation.

Thanks
Nikanth
