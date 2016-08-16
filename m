From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: lvmetad doesn't terminate with SIGTERM if thin
	volume used
Date: Tue, 16 Aug 2016 11:57:42 +0200
Message-ID: <78d5445c-e565-03ce-e586-2073aa7b0d99@redhat.com>
References: <CA+X5Wn6rX5rjFOhz-V3r9QYY_Mcp-0ddBTRDSuhq4Xyy2ob-7Q@mail.gmail.com>
	<CA+X5Wn5wn-engMAxvdqVSbK2bPo=9sz3485N3ZnCqGEZcQ79-Q@mail.gmail.com>
	<CA+X5Wn6DorjjziBD=R+60++bQgwAxDz_xvVsuv76u01Z8KKp6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+X5Wn6DorjjziBD=R+60++bQgwAxDz_xvVsuv76u01Z8KKp6g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: james harvey <jamespharvey20@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 6.8.2016 v 04:08 james harvey napsal(a):
> Same problem and question about if an immediate SIGKILL is OK for dmeventd.
>
> On Thu, Aug 4, 2016 at 11:20 PM, james harvey <jamespharvey20@gmail.com> wrote:
>> Does it matter at all if lvmetad shuts down gracefully?
>>
>> Can I safely just have systemd right off the bat send a SIGKILL?
>>
>> Most things I wouldn't ask about, but I'm wondering if this is PURELY
>> a caching daemon where gracefully shutting down doesn't really do
>> anything.
>>


Sigterm/sigint is ignored by dmeventd when device is monitored.

Before stopping dmevend - devices shall be unmonitored.
(vg/lvchange)

Killing 'dmeventd' in the middle of i.e. recovery operation might leave your 
system in dizzy state (suspended devices) essentially useless.


Somewhat similar ATM does apply to lvmetad - where lvm2 command will not like 
death of lvmetad in the middle of operation and this may result in operation 
failure (thought here the situation might get somewhat improved over the 
time...) - but ATM don't kill  - just stop services.

Fedora should be doing it properly on reboot - switching to ramdisk and
continuing with shutdown sequence from there.  Unsure how other OS-es solves this.

Using 'kill -9' (SIGKILL) is in general unsupported and any reported problems 
caused by this usage are ignored...

Regards

Zdenek
