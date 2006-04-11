From: Ed Wilts <ewilts@ewilts.org>
Subject: Re: Including Device Mapper packages on non-RedHat CD?
Date: Tue, 11 Apr 2006 11:45:44 -0500
Message-ID: <20060411164544.GB30601@www.ewilts.org>
References: <685C3297C32B524D94A9EF076C341C3C0A5698@XYUS-EX22.xyus.xyratex.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <685C3297C32B524D94A9EF076C341C3C0A5698@XYUS-EX22.xyus.xyratex.com>
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

On Mon, Apr 10, 2006 at 11:27:46AM -0700, Ryan Smith wrote:
> We would like to support DeviceMapper for our customers but want to make
> sure they have the latest bug fixes.  Some of our customers would be
> using DeviceMapper within a secure environment where there is no direct
> access to the internet.  To accomdate this we want to include the latest
> RPMs from RedHat in relation to DeviceMapper.
> 
> Examples may include:
> device-mapper-multipath-0.4.5-12.0.RHEL4.i386.rpm 
> device-mapper-1.02.02-3.0.RHEL4.i386.rpm
> 
> Would RedHat be okay with us including the DeviceMapper/Multipath RPMs
> on our CD?

I can't speak for Red Hat, I'm not a lawyer, and this list is not for
legal discussions, but the short answer is no.  Please read the
subscription agreement you have for RHEL 4 - it prevents you from
redistributing the binaries.

You may redistribute the source rpms that you can download from Red
Hat's FTP site, subject to terms of the license agreement and trademarks
for those sources, but the binaries aren't publicly available in the
first place.

You may, of course, contact Red Hat directly and request permission to
redistribute.  legal@redhat.com would be a good start.  Followups should
be directed to Red Hat's corporate offices - none of us are lawyers or
have the right to speak on behalf of Red hat.

        .../Ed

-- 
Ed Wilts, RHCE
Mounds View, MN, USA
mailto:ewilts@ewilts.org
Member #1, Red Hat Community Ambassador Program
