From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: Guide stacking device mappers
Date: Mon, 7 Aug 2017 16:23:39 +0900
Message-ID: <6557f958-8bb6-415d-3304-ef3f535e6b8c@gmail.com>
References: <HE1PR0301MB21562E7B9F051D3DA7484226A4B00@HE1PR0301MB2156.eurprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <HE1PR0301MB21562E7B9F051D3DA7484226A4B00@HE1PR0301MB2156.eurprd03.prod.outlook.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonas <jonasalmqvist@live.se>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Jonas,

I am developing dm-writeboost. Thank you for your interest.

I couldn't understand how you try to stack devices.
You should share diagram if you want others to know your idea precisely.

But this may help you. dm-writeboost can't use zram as the caching device.
I thought this is device-mapper's issue so you may confront this when you try the stacking.
https://github.com/akiradeveloper/dm-writeboost/issues/60

Akira

On 2017/08/03 6:00, Jonas wrote:
> 
> Hi
> 
> I want to write data to dm-dedup device, store that on a zram w lz4 compressed. Then dm-mirror the zram to dm-writeboost that have a Ssd as block device/final destination.
> 
> Is there any guide w examples on how to stack device mappers? Or anyone having instructions or guidlines on how to do?
> 
> /J
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
