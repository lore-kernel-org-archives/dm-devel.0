From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: shared snapshots
Date: Fri, 20 Feb 2009 17:58:21 -0600
Message-ID: <8EB48741-9FB1-4181-A1EE-993744C478D3@redhat.com>
References: <Pine.LNX.4.64.0902030118280.16888@hs20-bc2-1.build.redhat.com>
	<20090203154804V.fujita.tomonori@lab.ntt.co.jp>
	<A764D64A-56E6-46F3-9BA5-2A543D18CE48@redhat.com>
	<20090206161758K.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090206161758K.fujita.tomonori@lab.ntt.co.jp>
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


On Feb 6, 2009, at 1:18 AM, FUJITA Tomonori wrote:

> On Thu, 5 Feb 2009 16:17:29 -0600
> Jonathan Brassow <jbrassow@redhat.com> wrote:
>
>>
>> On Feb 3, 2009, at 12:48 AM, FUJITA Tomonori wrote:
>>
>>> But surely supporting the shared implementation(s) on the top of the
>>> existing snapshot code needs more refactoring. Jonathan, have you
>>> already started to work on it?
>>
>> I have a couple pending patches that I haven't sent to the list yet.
>> I'm hoping to get back to exception store API patches in a week or
>> two.  In the mean time, the current exception store API patches are
>> ready for review.  The additions to facilitate shared exception  
>> stores
>> will go on top of that patch set.
>
> Can you post the pending patches to the mailing list or put on a web
> site, please?

Guess I needed the whole two weeks, but I just posted the next wave of  
patches to the list.  I have to go back to some other work again next  
week, but I'm hoping to have time to dig into the "shared" exception  
store code to help you guys integrate into the given structure.  If  
not next week, then the week after.  :(

  brassow
