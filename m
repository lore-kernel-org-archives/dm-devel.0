From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: multipath-tools licenses (was Re: [PATCH]
 multipath-tools: replace FSF address with a www pointer)
Date: Wed, 28 Mar 2018 00:24:53 +0200
Message-ID: <904fd737-b8ff-016f-e33a-5d833ef33c3a@gmail.com>
References: <20180310205002.3318-1-xose.vazquez@gmail.com>
	<1521495458.3798.138.camel@suse.com>
	<1a0b44c5-c7a6-85fa-b2dd-1bd542efbb76@gmail.com>
	<1521837017.13100.106.camel@suse.com>
	<20180326130447.3114ef2f@pentland.suse.de>
	<1522067788.19335.55.camel@suse.com>
	<1522073719.19335.66.camel@suse.com>
	<20180326160705.GM3103@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180326160705.GM3103@octiron.msp.redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>, fge@redhat.com
List-Id: dm-devel.ids

On 03/26/2018 06:07 PM, Benjamin Marzinski wrote:

> If we can limit the project to two (or if necessary 3) licenses, we can
> just include all the license files, and explain what applies to what
> in the README.  I haven't really looked at how other projects that have
> multiple licenses for parts of their code do things, so perhaps there is
> a more standard way.

Multiple licences, for modules, are accepted in the Linux kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/module.h#n171

And the SPDX License Identifier is being used:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/license-rules.rst
