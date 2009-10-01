From: John Hughes <john@Calva.COM>
Subject: Re: multipath - AAArgh! How do I
	turn	"features=1	queue_if_no_path" off?
Date: Thu, 01 Oct 2009 10:55:12 +0200
Message-ID: <4AC46E70.9060509@Calva.COM>
References: <4AC333E2.9090005@Calva.COM> <20090930154212.GA8507@us.ibm.com>
	<4AC44B1E.7020509@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AC44B1E.7020509@suse.de>
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

Hannes Reinecke wrote:
> malahal@us.ibm.com wrote:
>> John Hughes [john@Calva.COM] wrote:
>>> I want to turn queue_if_no_path off and use
>>>
>>>                polling_interval        5
>>>                no_path_retry           5
>>>
>>> because I've had problems with things hanging when a lun "vanishes" 
>>> (I deleted it from my external raid box).
>>>
>>> But whatever I put in /etc/multipath.conf when I do a "multipath -l" 
>>> or "multipath-ll" it shows:
>>
>> Did you reload the mapper table?
>>
>>> 360024e80005b3add000001b64ab05c87dm-28 DELL    ,MD3000        
>>> [size=68G][features=1 queue_if_no_path][hwhandler=1 rdac]
>>> \_ round-robin 0 [prio=3][active]
>>> \_ 3:0:1:13 sdad 65:208 [active][ready]
>>> \_ round-robin 0 [prio=0][enabled]
>>> \_ 4:0:0:13 sdas 66:192 [active][ghost]
>>>
> Which is entirely correct. The 'queue_if_no_path' flag _has_ to
> be set here as we do want to retry failed paths, if only for
> a limited amount of retries.
>
> The in-kernel dm-multipath module should handle the situation correctly
> and switch off the queue_if_no_path flag (= pass I/O errors upwards)
> when the amount of retries is exhausted.
As far as I can tell it retries forever (even with polling_interval 5 
and no_path_retry 5).   The mdadm raid10 built on top of the multipath 
devices hangs, even /proc/mdstat hangs.

You're saying that without queue_if_no_path multipath basicly won't work 
- mdadm will see I/O errors on multipath devices if a path fails?
