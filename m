From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Question about dm target size
Date: Wed, 12 Nov 2014 12:48:03 +0100
Message-ID: <546348F3.90806@redhat.com>
References: <5462ABD8.1050609@fb.com>,
	<20141112020641.GA15589@redhat.com>	<fw2umnrmmu1mdtg0ab4f8stc.1415759451452@email.android.com>	<54631E1B.4090300@redhat.com>
	<54633DB0.8050800@fb.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54633DB0.8050800@fb.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, jbacik@fb.com
List-Id: dm-devel.ids

Dne 12.11.2014 v 12:00 Josef Bacik napsal(a):
> On 11/12/2014 03:45 AM, Zdenek Kabelac wrote:
>> Dne 12.11.2014 v 03:30 Josef Bacik napsal(a):
>>> Sorry for top posting, my phone client doesn't do inline.
>>>
>>> I'm splitting the disk in half, writing to alternating sides of the
>>> disk and keeping track of where which block is so when the power fail
>>> event occurs the subsequent reads come from the corresponding mirror
>>> in the disk. The disk needs to appear to be size/2 for the mkfs to
>>> know the correct size, but my target needs to be able to write up to
>>> size.  I looked at thinp but it reflects the full size right? It's
>>> just like a sparse find correct? My ->map function does the right
>>> thing, doing the ->len trick makes it all work out right, but this is
>>> really isolated testing. Thanks,
>>>
>>
>> Just a side note - maybe you would like to rather extend functionality
>> of dm-flakey  target ?
>>
>
> I did that first but it ended up being really ugly.  With all the varying
> functionality in dm-flakey it ended up making the table format horrible and
> the code a spaghetti of if (test_bit()) crap everywhere. Thanks,
>


The other thing that lvm2 test suite is using is -

we take a base 'linear' device mapped on some origin - and we create a 
segmented device where individual segment are either mapper to 'original' 
device or to a 'zero' origin or  'error' origin depending on
whether you want to read  0 or 'err' from a device.

Example of such mapping 'trick':

normal mapping for device pv1:

pv1: 0 69120 linear 7:2 0


mapping with single error segment sector of device pv1:

pv1: 0 2050 linear 7:2 0
pv1: 2050 1 error
pv1: 2051 67069 linear 7:2 2051

You could reload table mapping for pv1 any-time with suspend/resume.


Zdenek
