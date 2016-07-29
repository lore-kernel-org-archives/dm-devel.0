From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: dm-flakey NOT to return -EIO on READ?
Date: Fri, 29 Jul 2016 15:32:46 +0900
Message-ID: <0dc69d8f-1595-1677-5028-f920d7b54eb0@gmail.com>
References: <217a0cf8-4853-6316-3016-77460073061d@gmail.com>
	<CAM4Jq_5kBs2WKNOiLrVL8XMTSJQhPdvO-XKROhzpLXdOATFw7w@mail.gmail.com>
	<07b6affb-a09d-7d55-65f8-6d476a5471aa@gmail.com>
	<f059f3f1-a860-aee5-20b7-d6b3ed6b467d@gmail.com>
	<CAM4Jq_7WWFsviFXeAYa5gd_wrL73Fuz0goXbzG7Q-dYujkh1ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAM4Jq_7WWFsviFXeAYa5gd_wrL73Fuz0goXbzG7Q-dYujkh1ag@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Lukas Herbolt <lherbolt@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Lukas,

> I have patch ready, would you be able to test it before posting it.
> 
> Let me know if I should build the kernel for you or just share the source
> with you.

OK.
Please share the git tree and specify the branch to test.

Akira

On 2016/07/29 15:25, Lukas Herbolt wrote:
> Hi Akira,
> Sorry I was on holiday.
> I have patch ready, would you be able to test it before posting it.
> 
> Let me know if I should build the kernel for you or just share the source
> with you.
> 
> Lukas
> 
> On Sun, Jul 17, 2016 at 3:36 AM, Akira Hayakawa <ruby.wktk@gmail.com> wrote:
> 
>>> On 2016/07/06 18:52, Lukas Herbolt wrote:
>>>> Hi,
>>>> Yes this part is wrong and reads are not dropped.
>>>> I have a patch ready, just have to send it out.
>>
>> btw, is this fix going to be included in the next release?
>>
>> On 2016/07/06 21:54, Akira Hayakawa wrote:
>>> Thanks,
>>>
>>> I want the patch in the main-tree quickly.
>>> Because without it, my tests will not be green.
>>> This is really annoying.
>>>
>>> I made a quick reproducer of this problem.
>>> If you are looking for one, this will help.
>>> (You need to install sbt first)
>>>
>>> https://github.com/akiradeveloper/writeboost-test-suite
>>>
>>>   test("flakey (read)") {
>>>     Memory(Sector.M(16)) { a =>
>>>       Flakey.Table(a, 0, 1).create { b =>
>>>         intercept[Exception] {
>>>           Shell(s"dd status=none if=${b.bdev.path} iflag=direct
>> of=/dev/null")
>>>         }
>>>       }
>>>     }
>>>   }
>>>
>>> $ sudo sbt "testOnly dmtest.FlakeyTest"
>>> 12:44:00.643 [pool-2-thread-3-ScalaTest-running-FlakeyTest] INFO dmtest
>> - [TEST] flakey (read)
>>> 12:44:00.752 [pool-2-thread-3-ScalaTest-running-FlakeyTest] DEBUG dmtest
>> - reload: table=0 32768 flakey /dev/loop0 0 0 1
>>> [info] FlakeyTest:
>>> [info] - flakey (read) *** FAILED ***
>>> [info]   Expected exception java.lang.Exception to be thrown, but no
>> exception was thrown. (FlakeyTest.scala:9)
>>> [info] Run completed in 2 seconds, 781 milliseconds.
>>> [info] Total number of tests run: 1
>>> [info] Suites: completed 1, aborted 0
>>> [info] Tests: succeeded 0, failed 1, canceled 0, ignored 0, pending 0
>>>
>>> - Akira
>>>
>>> On 2016/07/06 18:52, Lukas Herbolt wrote:
>>>> Hi,
>>>> Yes this part is wrong and reads are not dropped.
>>>> I have a patch ready, just have to send it out.
>>>>
>>>> Lukas
>>>>
>>>> On Wed, Jul 6, 2016 at 8:33 AM, Akira Hayakawa <ruby.wktk@gmail.com>
>> wrote:
>>>>
>>>>> Hi,
>>>>>
>>>>> I am using dm-flakey to emulate a broken device that should return
>> -EIO on
>>>>> both read and write.
>>>>> I use the parameter up_interval=0 and down_interval=1.
>>>>>
>>>>> But when I am dd-ing the flakey device, while write fails, read
>> succeeds.
>>>>> This isn't the behavior I expect.
>>>>>
>>>>> Then I looked into the code.
>>>>>
>>>>> 326 static int flakey_end_io(struct dm_target *ti, struct bio *bio, int
>>>>> error)
>>>>> 327 {
>>>>> 328         struct flakey_c *fc = ti->private;
>>>>> 329         struct per_bio_data *pb = dm_per_bio_data(bio,
>> sizeof(struct
>>>>> per_bio_data));
>>>>> 330
>>>>> 331         /*
>>>>> 332          * Corrupt successful READs while in down state.
>>>>> 333          * If flags were specified, only corrupt those that match.
>>>>> 334          */
>>>>> 335         if (fc->corrupt_bio_byte && !error && pb->bio_submitted &&
>>>>> 336             (bio_data_dir(bio) == READ) && (fc->corrupt_bio_rw ==
>>>>> READ) &&
>>>>> 337             all_corrupt_bio_flags_match(bio, fc))
>>>>> 338                 corrupt_bio_data(bio, fc);
>>>>> 339
>>>>> 340         return error;
>>>>> 341 }
>>>>>
>>>>> When the bio direction is READ and currupt_bio_bytes isn't specified
>>>>> the READ bio is handled normally right?
>>>>>
>>>>> I think READ requests should return -EIO if
>>>>>
>>>>> 1. corrupt_bio_bytes isn't specified
>>>>> 2. but the requested is handled during down interval.
>>>>>
>>>>> as well as WRITE requests:
>>>>>
>>>>> 305                 /*
>>>>> 306                  * Corrupt matching writes.
>>>>> 307                  */
>>>>> 308                 if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw ==
>>>>> WRITE)) {
>>>>> 309                         if (all_corrupt_bio_flags_match(bio, fc))
>>>>> 310                                 corrupt_bio_data(bio, fc);
>>>>> 311                         goto map_bio;
>>>>> 312                 }
>>>>> 313
>>>>> 314                 /*
>>>>> 315                  * By default, error all I/O.
>>>>> 316                  */
>>>>> 317                 return -EIO;
>>>>> 318         }
>>>>>
>>>>> This code is similar to what we see in the end_io.
>>>>>
>>>>> If my understanding is correct, I would like to modify dm-flakey to
>> return
>>>>> -EIO in the end_io.
>>>>>
>>>>> I would like to request for comments.
>>>>>
>>>>> Thanks,
>>>>>
>>>>> - Akira
>>>>>
>>>>> --
>>>>> dm-devel mailing list
>>>>> dm-devel@redhat.com
>>>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>>>>
>>>>
>>>>
>>>>
>>
> 
> 
> 
