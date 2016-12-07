From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: replace multipath
 configuration output
Date: Wed, 7 Dec 2016 16:44:22 +0100
Message-ID: <d793306a-011a-2332-9c81-3dd898aff44a@gmail.com>
References: <20161124224427.12609-1-xose.vazquez@gmail.com>
	<1480064411.23852.1.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1480064411.23852.1.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 11/25/2016 10:00 AM, Martin Wilck wrote:

> I am not sure I see the merit of these changes. If it's really
> necessary to change the wording of the log messages which people have
> got used to, the new ones should be really more self-explanatory than
> the old ones.

Some of them are a riddle, wrapped in a mystery, inside an enigma.
For example "LUN setting". "setting: multipath.conf multipaths section"
is, by far, a better description.

> The common "setting: " formatting is nice but IMHO this alone doesn't
> really justify overthrowing old habits.

I really don't care the marker name, "setting:" "conf:" ...
But a standard one should be used.

> On Thu, 2016-11-24 at 23:44 +0100, Xose Vazquez Perez wrote:
>> sysfs setting           -> setting: kernel sysfs
>>
>> detected setting        -> setting: array autodetected
>>
>> controller setting      -> setting: array configuration

> Is "array" really more understandable to users than "controller"?

"controller", what controller? local hba? array controller?
"array" is unequivocal.

> These settings come from hwentries, so in reality they're either part
> of the built-in hwtable or of the multipath.conf "devices" section, or
> am I wrong here? 

Also from /sys fs, from the array or auto-negotiated kernel<->array.

>> internal default        -> setting: multipath internal
>>
>> overrides setting       -> setting: multipath.conf overrides section
>>
>> LUN setting             -> setting: multipath.conf multipaths section
>>
>> config file default
>> config file setting     -> setting: multipath.conf defaults/devices
>> section

> Have you double-checked if this is correct for all options?

Yes. I don't do random patches.

> It would be helpful for users to be able to distinguish which config file section
> the option was taken from (defaults/devices/multipaths/overrides). The
> same argument applies to the hardware enries - being able to
> distinguish built in hardware defaults from config file "devices"
> settings would be really helpful, but this patch doesn't provide that
> functionality.

This is a first step. Anyhow only "multipath.conf defaults/devices" could be split.
overrides and multipaths sections already are independent as you can see in
libmultipath/propsel.c
