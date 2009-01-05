From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Mon, 05 Jan 2009 10:44:27 -0500
Message-ID: <49622ADB.7040200@redhat.com>
References: <492C91DF.7040507@redhat.com>
	<ACCFADCE-51D8-4183-803D-32050E3BE436@redhat.com>
	<49467039.6060801@redhat.com> <20081220001305.GA8574@us.ibm.com>
	<49502F7E.9040300@redhat.com> <20081223180228.GA24831@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081223180228.GA24831@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: malahal@us.ibm.com
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Malahal,

Sorry for my late reply.

malahal@us.ibm.com wrote:
> Takahiro Yasui [tyasui@redhat.com] wrote:
>> Hi Malahal,
>>> A while back IBM posted a patch to LVM that constructs a log device with
>>> a mirror and then creates the real mirror using such a mirrored log
>>> device. I think this may solve your problem. It was completely written
>>> in LVM and Stefan refreshed it to the latest LVM.
>> Thank you for the comment and information. It seems that your
>> approach seems to address my problem, too. Here I have a concern
>> about write performance because an additional mirror mapping might
>> introduce additional delay and overhead. In addition, error for
>> log devices is better to be handled by the simple way, and a basic
>> error handling would work.
> 
> In theory yes, but I doubt it would be user visible that much. We expect
> transient failures under some circumstances, so we would like to handle
> them. In other words, a failed device is expected to come back and the
> mirror target should re-integrate it automatically when it comes back.
> Can your multi-log code handle re-synchronizing a log device?

my patch doesn't handle transient error now. I expect log devices
to be failed and got in a blockage status once an error has happened.

> With our user level only implementation, the log device handling would
> be as good as the real mirror *leg* handling. We get all the benefits of
> the mirror without doing any code! Wouldn't it be nice?

I agree that simple implementation is better, but log could be handled
without any additional layer, and also I'm thinking that log could be
handled in the simpler way.

Lower layer, such as SCSI, also has retry feature based on error type
and will be done in the proper way. Do you mean that it isn't enough
and should dm-layer handle errors for log device, too?

I introduced multi-log feature so that system can keep running even if
the lower layer could not recover errors.

Thanks,
Taka
