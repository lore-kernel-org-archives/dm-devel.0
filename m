From: Abhishek Gupta <agupta@cs.ubc.ca>
Subject: Re: [PATCH] Fixes for clone_bio and __clone_and_map
	functions in dm.c
Date: Mon, 20 Mar 2006 20:34:32 -0800 (PST)
Message-ID: <Pine.GSO.4.60.0603202032490.29527@cascade.cs.ubc.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Alasdair,

>> I found a small bug in the clone_bio() function in dm.c . The number of 
bio
>> vectors in the cloned bio is incorrectly set to the index of the last 
bio
>> vector in its range. I have corrected it in the attached patch.

> I don't see that yet - the code is not very transparent though.
> (Look at the places that call the function.)

I am a little confused about why is this not a problem. Isn't 
clone->bi_vcnt 
supposed to hold the number of bio vectors in the clone? Why does it hold 
idx+bv_count instead? Please clarify.

Thanks

Abhishek
