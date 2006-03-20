From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Fixes for clone_bio and __clone_and_map
	functions in dm.c
Date: Mon, 20 Mar 2006 00:04:41 +0000
Message-ID: <20060320000441.GB26428@agk.surrey.redhat.com>
References: <Pine.GSO.4.60.0603191017150.8166@cascade.cs.ubc.ca>
	<5055b5c00603191024q5e8212b7rbb5074182cc31474@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5055b5c00603191024q5e8212b7rbb5074182cc31474@mail.gmail.com>
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

On Sun, Mar 19, 2006 at 10:24:00AM -0800, Abhishek Gupta wrote:
> I found a small bug in the clone_bio() function in dm.c . The number of bio
> vectors in the cloned bio is incorrectly set to the index of the last bio
> vector in its range. I have corrected it in the attached patch.

I don't see that yet - the code is not very transparent though.
(Look at the places that call the function.)
 
> I encountered another problem in the final else condition of
> __clone_and_map()
> function where the bio vector is split in to two parts. 

Yes, that looks wrong, as Dan reported on IRC this week.
The patch needs a little tidying up though.
[only one split_bvec() call not two?
 reconsider loop entry/exit to avoid artificial-looking exit?]

Alasdair
-- 
agk@redhat.com
