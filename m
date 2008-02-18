From: malahal@us.ibm.com
Subject: Re: Multipath not rebuilding correctly on reboot
Date: Mon, 18 Feb 2008 14:20:14 -0800
Message-ID: <20080218222014.GA26319@us.ibm.com>
References: <20080217074708.GA17721@us.ibm.com>
	<2F1F44D192D1284BAA298E48C1B2A4F90234F1FC@exchmail03.ncogroup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2F1F44D192D1284BAA298E48C1B2A4F90234F1FC@exchmail03.ncogroup.com>
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

Greene, Rick [rick.greene@ncogroup.com] wrote:
> Quick question...what RPM would I find udevsettle in? Doesn't appear to
> be installed on my system (RedHat Enterprise Linux 4), nor can I find
> reference to it on RedHat's site.

Part of udev rpm (udev-085-30.37) on my system (SLES10 SP1). Maybe RHEL4
has an older version of udev that lacks udevsettle. That explains why
they used a "sleep"!

--Malahal.
