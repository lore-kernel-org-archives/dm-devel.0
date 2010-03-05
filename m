From: malahal@us.ibm.com
Subject: Re: Boot Problems with Multipath
Date: Fri, 5 Mar 2010 10:33:18 -0800
Message-ID: <20100305183318.GA22835@us.ibm.com>
References: <c6143162346dbd7d9212f46bb5115ae6.squirrel@fela.liber4e.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <c6143162346dbd7d9212f46bb5115ae6.squirrel@fela.liber4e.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

jose nuno neto [jose.neto@liber4e.com] wrote:
> Hi2all
> 
> I was doing some testing on multipath on san and copied a
> /etc/multipath.conf from one machine to another. each machine has local
> disk for / and all OS partitions. San/multipath is used only on data.
> I had black list local disk on /etc/multipath.conf but when I copied from
> one machine to the other...no longer blacklist
> After this ( i didn't noticed the error ) I issue a mkinitrd
> 
> After all this when rebooting the machine with the wrong local disk black
> list, the boot hangs after setting hostname, wtih message "cannot create
> directory /var/lib filesystem read only"
> 
> I have gonne into rescue mode, rebuild initrd, disable friendy_names
> option ( read some references about it) but cant boot. Now no create
> directory errors but doesn't go after setting hostname
> 
> Any clues on how to fix it?

Create /var/lib/multipath/bindings file and reboot.
