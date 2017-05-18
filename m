From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: dm-verity OOPSes on kernel 4.12rc
Date: Thu, 18 May 2017 13:25:08 +0300
Message-ID: <CAOtvUMdhP2UR-zd79j8PvkBzUq36X4DW6cV1m951SEY5a8bJqQ@mail.gmail.com>
References: <2c50482c-e515-297e-288b-8a4bce093838@redhat.com>
	<6a0bb9db-6270-aafd-4618-71963e7d97b1@gmail.com>
	<CAOtvUMd8z90UE3w+oABJ3_970H5gMbQoH8E8kHHs4+i=dKX9LA@mail.gmail.com>
	<a5989b0e-af62-c782-f20b-c3c95c282437@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a5989b0e-af62-c782-f20b-c3c95c282437@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Marian Csontos <mcsontos@redhat.com>
List-Id: dm-devel.ids

On Thu, May 18, 2017 at 10:18 AM, Milan Broz <gmazyland@gmail.com> wrote:
> On 05/18/2017 08:55 AM, Gilad Ben-Yossef wrote:
>> On Thu, May 18, 2017 at 9:37 AM, Milan Broz <gmazyland@gmail.com> wrote:
>>> Hi Gilad,
>>>
>>> seems this OOPs is caused by async crypto hash changes in 4.12 for dm-verity.
>>>
>>
>> Oy, that is not good.
>>
>>> Could you please check if it is some known problem?
>>>
>>
>> I am not aware of any problem but of course I will try to reproduce an debug.
>>
>>> Fedora rawhide x86_64 (with 4.12rc patches) crashes always,
>>> running verity-compat-test from cryptsetup testsuite is enough to trigger this.
>>>
>>> I am not able to reproduce it on other distro but I guess it is just
>>> some kernel debugging switch that is enabled in Fedora by default.
>>>
>>
>> hmm... looking at the trace - there seems to be buffer io errors *before* the
>> BUG assert.  That is surprising for a KVM run.
>>
>> Also the code path triggering this I believe is when we read hash blocks.
>> Possibly this is triggered by an IO request failing and than we continue
>> with trying to hash the block. This is just a guess... I will take a look.
>
> Thanks!
>
> FYI, I am able to reproduce it on 32bit kernel as well,
> git from Linus' tree updated today.

OK, I know what the problem is. It's triggered by having no salt value.

Testing fix...

Thanks all,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
