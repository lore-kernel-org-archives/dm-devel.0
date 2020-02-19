From: Martin Wilck <mwilck@suse.com>
Subject: RFC: multipath-tools: NVMe native multipath and default
 setting for "enable_foreign"
Date: Wed, 19 Feb 2020 17:17:48 +0100
Message-ID: <8f4d39d663aad324017297db0d31a0a24369c9a4.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: "George, Martin" <Martin.George@netapp.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, "Schremmer,
	Steven" <Steve.Schremmer@netapp.com>, JulianAndresKlode <julian.klode@canonical.com>
List-Id: dm-devel.ids

multipath-tools has support for "foreign" libraries in multipath-tools
since 0.8.0, and support for enabling/disabling them at runtime since
0.8.3.

The only foreign library that exists is "nvme" (for native NVMe
multipath), and it's likely to remain so for some time. Currently
upstream multipath-tools ships with all foreign libraries enabled by
default, and documentation about how to disable them.

There's an ongoing discussion between myself and folks from Netapp
about changing the code such that the nvme library is disabled by
default. People at Netapp are worried that multipath's output for NVMe
native multipath maps would confuse customers and break scripts.
I've suggested that Netapp simply ship a drop-in configuration file
to be put in /etc/multipath/conf.d to disable the nvme library, but I'm
told that customers are wary about vendor-supplied configuration files.

For SUSE's enterprise product, SLE, we have made this change and
disabled the nvme library by default. Now Netapp is asking me to
forward this change upstream. Personally, I'm not too fond of the
proposal, because I think the original idea (enable people to use the
tools they are used to) is still valid (*). OTOH, the "nvme" tool can
provide similar information and is likely to be used by NVMe users
anyway, so perhaps there's no urgent need for this functionality in
multipath-tools any more.

I really don't know if people out there find this feature rather
helpful or rather confusing. Therefore I'd like to ask for opinions
here on the list.

Regards,
Martin

(*) Also because I, myself, have put quite some effort into the
"foreign/nvme" feature and wouldn't be happy to see it go away. 
