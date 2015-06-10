From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: Trying to us dmcache with zram block device
Date: Wed, 10 Jun 2015 17:00:30 +0900
Message-ID: <5577EE9E.8020807@gmail.com>
References: <1387413069.4019.17.camel@daniel.ewheeler.net>
	<20131220164319.GB15982@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131220164319.GB15982@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi,

Sorry to interrupt.

A similar issue is reported with dm-writeboost and zram cache device.
The bug there is that metadata read failed in initialization.

Do you have some advance on this issue?
I am wondering if it's device-mapper that misbehaves.

- Akira

On 2013/12/21 1:43, Joe Thornber wrote:
> On Wed, Dec 18, 2013 at 04:31:09PM -0800, Daniel Wheeler wrote:
>> Can you think of any reason that zram cannot be a cache for dmcache devices?
>>
>> If this is a bug, does it reside in dmcache or in zram?
> 
> Hmm, not sure what's going on here.  We'll try and set up a similar test.
> 
> - Joe
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
