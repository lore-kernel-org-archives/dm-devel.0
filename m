From: malahal@us.ibm.com
Subject: Re: Installing RHEL with single controller
Date: Thu, 28 Feb 2008 11:21:35 -0800
Message-ID: <20080228192135.GA13340@us.ibm.com>
References: <110b17190802281008u6e5eeef4vccfb509be7ad4198@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <110b17190802281008u6e5eeef4vccfb509be7ad4198@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Pradipmaya Maharana [pradipmaya@gmail.com] wrote:
> Hi All,
> 
> I installed RHEL on a blade with only one LUN and with only one controller up.
> So for obvious reasons, even though I specified the option "linux
> mpath" for installer, the only device available for partition was
> /dev/sda/.

Don't know what the installer does in this case, so check your initrd if
multipath is enabled. If not, there should be a way to generate
multipath capable initrd by running 'mkinitrd'. You may need to update
some files before running mkinitrd to poduce multipath capable initrd...

--Malahal.
