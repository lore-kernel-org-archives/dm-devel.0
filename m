From: Josef Bacik <jbacik@fb.com>
Subject: Re: Question about dm target size
Date: Wed, 12 Nov 2014 06:00:00 -0500
Message-ID: <54633DB0.8050800@fb.com>
References: <5462ABD8.1050609@fb.com>,
	<20141112020641.GA15589@redhat.com>	<fw2umnrmmu1mdtg0ab4f8stc.1415759451452@email.android.com>
	<54631E1B.4090300@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54631E1B.4090300@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 11/12/2014 03:45 AM, Zdenek Kabelac wrote:
> Dne 12.11.2014 v 03:30 Josef Bacik napsal(a):
>> Sorry for top posting, my phone client doesn't do inline.
>>
>> I'm splitting the disk in half, writing to alternating sides of the
>> disk and keeping track of where which block is so when the power fail
>> event occurs the subsequent reads come from the corresponding mirror
>> in the disk. The disk needs to appear to be size/2 for the mkfs to
>> know the correct size, but my target needs to be able to write up to
>> size.  I looked at thinp but it reflects the full size right? It's
>> just like a sparse find correct? My ->map function does the right
>> thing, doing the ->len trick makes it all work out right, but this is
>> really isolated testing. Thanks,
>>
>
> Just a side note - maybe you would like to rather extend functionality
> of dm-flakey  target ?
>

I did that first but it ended up being really ugly.  With all the 
varying functionality in dm-flakey it ended up making the table format 
horrible and the code a spaghetti of if (test_bit()) crap everywhere. 
Thanks,

Josef
