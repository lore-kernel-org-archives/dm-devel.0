From: malahal@us.ibm.com
Subject: Re: Improving mirror fault handling.
Date: Mon, 12 Jan 2009 19:26:52 -0800
Message-ID: <20090113032652.GA27493@us.ibm.com>
References: <1231802846.10230.65.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1231802846.10230.65.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, jbrassow@redhat.com
List-Id: dm-devel.ids

Jonathan Brassow [jbrassow@redhat.com] wrote:
>  *    A => Alive - No failures
>  *    D => Dead - A write failure occurred leaving mirror out-of-sync
>  *    S => Sync - A sychronization failure occurred, mirror out-of-sync
>  *    R => Read - A read failure occurred, mirror data unaffected
> We can do so much more with this information than the immediate removal
> of an offending device.  'S' could cause us to simply suspend/resume the
> device to restart the resynchronization process - giving us another shot
> at it.  'R' could mean that we have a unrecoverable read error - a block
> relocation might be initiated via a write.  In the case of a 'D', we
> could wait some user configured amount of time (or %'age out of sync)
> before removing the offending device, as it could be a transient
> failure.
> 
> 2) Improve parsing of mirror status output in the DSO
> - Location => LVM2/daemons/dmeventd/plugins/mirror/dmeventd_mirror.c
> - Be able to determine failure types (need more states then just
> 'ME_FAILURE')
> - At the very least, we improve the log messages at this phase and it
> sets us up to improve the handling of each error type - potentially
> ignoring some error types for now (like read failures).
> 
> 3) Implement different methods to handle the different error types
> 
> 4) Transient fault handling
> - Since we can't just assume "wait 5 seconds and then see if the failure
> still exists", we are going to have to make this configurable.
> Discussion should proceed on this in parallel with #2 and #3, since this
> phase will take a long time for everyone to agree.  We have to determine
> where the user specifies the configuration - lvm.conf?  CLI?  We also
> have to determine /what/ their configuration will be based on - time?
> percentage of mirror out-of-sync?

Thank you Jonathan for the nice write up. Transient failure are
generally recoverable after a period of time. The 'time' may vary from
device to device though. lvm.conf based configuration is a good place to
start. Do we really need LV or PV based configuration for this
'timeout'?

The recovery itself doesn't depend on the %of out-of-sync regions, but
that is a good place to start looking for re-allocating the regions if
configured for re-allocation.

Here are my thoughts:
	handle_mirror_transient_failure()
	{
		do {
			if (device-came-back-to-life()) {
				start-resynchronization();
				break;
			}

			if (reallocation-timeout exceeded or
			    re-allocation-too-much out-of-sync) {
				re-allocate();
				break;
			}
			if (some-other-timeout exceeded) {
				log a message and break;
			}
			sleep(for-few-seconds);
			timeout =- few-seconds;
		} while (1)
	}

Thanks, Malahal.
