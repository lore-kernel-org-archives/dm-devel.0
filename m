From: URZ- AG <arsene.gschwind@unibas.ch>
Subject: Multipath blacklisted devices
Date: Thu, 20 Apr 2006 19:57:24 +0200
Message-ID: <4447CB84.6060804@unibas.ch>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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

Hi,

I'm using the latest git version of multipath-tools with a 2.6.16 kernel.
Today I've tried to blacklist a scsi device in the multipath.conf file=20
using the following entry:
        devnode "^(sda)[0-9]*"

This didn't work at all, it seems that multipath doesn't use the=20
blacklist entries found in multipatch.conf.
I've patched the source code to hardcode that device and this works well.
I've tried to debug the config loading but my C knowledge is too poor=20
and I haven't been able to find out whats wrong so far.
Any help for debugging would be greatly apreciated, I've tried to write=20
some code which dumps all entries read from the config file but it=20
didn't work so far.

Thanks for your time and great work,
Ars=E8ne
