From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RHEL6.2: path failures during good path I/O
Date: Thu, 14 Jun 2012 17:19:29 -0400
Message-ID: <20120614211928.GA30587@redhat.com>
References: <4FD87335.3040300@linux.vnet.ibm.com>
	<20120613131613.GA18293@redhat.com>
	<4FDA3840.9030307@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4FDA3840.9030307@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christian May <cmay@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 14 2012 at  3:15pm -0400,
Christian May <cmay@linux.vnet.ibm.com> wrote:

> I couldn't recreate the path failures on the exact same test setup
> with RHEL6.1.
> 
> Something must have been changed in the device-mapper package!?

It is good to know 6.1 works and 6.2 doesn't for you.  But I'm not
understanding why you're thinking it is a device-mapper-multipath
issue (not kernel issue).

You could do a couple things:
1) run the RHEL6.2 kernel on a RHEL6.1 install
2) install RHEL6.1 device-mapper-multipath package on RHEL6.2 install

If both work then it implicates the RHEL6.2 device-mapper-multipath
package.

But all being said, please just file a BZ at bugzilla.redhat.com
