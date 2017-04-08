From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] kobject: support passing in variables for
 synthetic uevents
Date: Sat, 8 Apr 2017 18:18:37 +0200
Message-ID: <20170408161837.GA27387@kroah.com>
References: <20170315151724.4696-1-prajnoha@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170315151724.4696-1-prajnoha@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Rajnoha <prajnoha@redhat.com>
Cc: jeyu@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, kay@redhat.com, dm-devel@redhat.com, harald@redhat.com
List-Id: dm-devel.ids

On Wed, Mar 15, 2017 at 04:17:24PM +0100, Peter Rajnoha wrote:
> This patch makes it possible to pass additional arguments in addition
> to uevent action name when writing /sys/.../uevent attribute. These
> additional arguments are then inserted into generated synthetic uevent
> as additional environment variables.
> 
> Before, we were not able to pass any additional uevent environment
> variables for synthetic uevents. This made it hard to identify such uevents
> properly in userspace to make proper distinction between genuine uevents
> originating from kernel and synthetic uevents triggered from userspace.
> Also, it was not possible to pass any additional information which would
> make it possible to optimize and change the way the synthetic uevents are
> processed back in userspace based on the originating environment of the
> triggering action in userspace. With the extra additional variables, we are
> able to pass through this extra information needed and also it makes it
> possible to synchronize with such synthetic uevents as they can be clearly
> identified back in userspace.
> 
> The format for writing the uevent attribute is following:
> 
>         ACTION [UUID [KEY=VALUE ...]
> 
> There's no change in how "ACTION" is recognized - it stays the same
> ("add", "change", "remove"). The "ACTION" is the only argument required
> to generate synthetic uevent, the rest of arguments, that this patch
> adds support for, are optional.
> 
> The "UUID" is considered as transaction identifier so it's possible to
> use the same UUID value for one or more synthetic uevents in which case
> we logically group these uevents together for any userspace listeners.
> The "UUID" is expected to be in "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
> format where "x" is a hex digit. The value appears in uevent as
> "SYNTH_UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" environment variable.
> 
> The "KEY=VALUE" pairs can contain alphanumeric characters only. It's
> possible to define zero or more more pairs - each pair is then delimited
> by a space character " ". Each pair appears in synthetic uevents as
> "SYNTH_ARG_KEY=VALUE" environment variable. That means the KEY name gains
> "SYNTH_ARG_" prefix to avoid possible collisions with existing variables.
> To pass the "KEY=VALUE" pairs, it's also required to pass in the "UUID"
> part for the synthetic uevent first.
> 
> If "UUID" is not passed in, the generated synthetic uevent gains
> "SYNTH_UUID=0" environment variable automatically so it's possible to
> identify this situation in userspace when reading generated uevent and so
> we can still make a difference between genuine and synthetic uevents.
> 
> Signed-off-by: Peter Rajnoha <prajnoha@redhat.com>

This looks fine to me, but you need to document it somewhere.  Is there
an existing Documenation/ABI/ entry for this sysfs file?  If not, can
you add it?

thanks,

greg k-h
