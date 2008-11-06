From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: multipath-tools Patch Submission - mpath_prop_class
	callout
Date: Thu, 6 Nov 2008 12:47:50 -0800
Message-ID: <20081106204750.GA14092@linux.vnet.ibm.com>
References: <9A7F9F83A843AD4EBDE53D0D868ECD4203471F24@NTST-OH-MAIL01.ntst.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <9A7F9F83A843AD4EBDE53D0D868ECD4203471F24@NTST-OH-MAIL01.ntst.com>
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
Cc: cristophe.varoqui@free.fr
List-Id: dm-devel.ids

Jeff McCune <JMcCune@ntst.com> wrote:
> 
> Hi,
> 
> Where might I read about the procedure for submitting a patch to
> multipath-tools?
> 
> I've written a very small mpath_prio_class program, which I'm currently
> using to assign fibre channel paths a priority of 40, and iSCSI paths a
> priority of 10, and I'd like to submit this for inclusion in the
> device-mapper-multipath package.  This program facilitates failover and
> failback from fibre to iscsi paths.
> 
> >From http://sources.redhat.com/dm/  I've wandered to
> http://christophe.varoqui.free.fr/ which states the git repository is
> located at http://kernel.org/pub/scm/linux/storage/multipath-tools/ but
> I receive the following error when I attempt to clone it:
> 
> [jmccune@homer dev]$ git clone
> http://kernel.org/pub/scm/linux/storage/multipath-tools/
> Initialized empty Git repository in
> /asp/home/jmccune/dev/multipath-tools/.git/
> Cannot get remote repository information.
> Perhaps git-update-server-info needs to be run there?

Can you try the git url?

git clone git://git.kernel.org/pub/scm/linux/storage/multipath-tools/.git

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
