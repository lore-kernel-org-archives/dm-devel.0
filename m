From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [Question] dm-cache table
Date: Wed, 27 Nov 2013 10:54:04 +0900
Message-ID: <529550BC.2040009@gmail.com>
References: <52932C6F.5000306@gmail.com> <20131125120512.GC10831@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131125120512.GC10831@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Joe,

> On Mon, Nov 25, 2013 at 07:54:39PM +0900, Akira Hayakawa wrote:
>> If it accepted migrate_threshold in .ctr and the parameter
>> changed later. The actual value and what is seen in table
>> become inconsistent right? Is this intentionally designed?
> 
> No, this is a bug.

So, the table design should be fully consistent with the actual values?

The only essential property of the table output is that it can
recreate the same device?
Your device-mapper-test-suite seems to use this property to make
a thoroughly new device to test.

I am wondering the table design in writeboost.
writeboost takes 'optional args' in .ctr each defined default value.
Let the values name k1 and k2, and the default values v1 and v2.
Assume only k1 v1' (!= v1) is passed to the .ctr in building the device
and the internal values are {k1:v1', k2:v2} of course then
what should the table look like? k2 v2 should included?

Also, writeboost takes 'tunable args' following the optional args.
They can be changed while running.
Should the table be consistent with the updated values is my wondering
that makes me ask you the question in the previous mail.
There could be an another way of thinking about the tunable things
that it doesn't have to be included in table because it can tuned
after all.


Just for information, this is the current sample lines
to initialize writeboost device.
dmsetup create writeboost-vol --table "0 ${sz} 0 writeboost ${BACKING} {CACHE}"
dmsetup create writeboost-vol --table "0 ${sz} 0 writeboost ${BACKING} {CACHE} \
                                       4 rambuf_pool_amount 8192 segment_size_order 8 \
                                       2 allow_migrate 1"
dmsetup create writeboost-vol --table "0 ${sz} 0 writeboost ${BACKING} {CACHE} \
                                       0 \
                                       2 allow_migrate 1"


Thanks,
Akira
