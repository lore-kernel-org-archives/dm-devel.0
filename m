From: malahal@us.ibm.com
Subject: Re: Multipath and getuid_callout issues with
	HPXP1024diskarray
Date: Thu, 7 Feb 2008 11:53:09 -0800
Message-ID: <20080207195309.GA7566@us.ibm.com>
References: <20080207083902.GB7665@percy.comedia.it>
	<2F1F44D192D1284BAA298E48C1B2A4F90234F195@exchmail03.ncogroup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2F1F44D192D1284BAA298E48C1B2A4F90234F195@exchmail03.ncogroup.com>
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
> Works fine, except for an odd issue at reboot times, for which I've got
> a separate unanswered query out to this list.

Is it possible that your paths were not ready when multipath tried to
configure your paths as part of the boot process? Will they get
configured correctly when you restart the rc service (multipathd)?
If they get configured correctly when you run 'service multipathd
restart', I would assume that the problem is udev related, and a
udevsettle in the /etc/init.d/multipathd init script may help!

I am out of ideas and just shooting in the dark! :-)

--Malahal.
