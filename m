From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RHEL 6 I/O error messages during booting
Date: Tue, 10 May 2011 17:57:29 -0400
Message-ID: <20110510215729.GC1045@redhat.com>
References: <OF01186CE2.F2A5FC34-ONC1257887.00332068-C1257887.003C3C98@de.ibm.com>
	<1305052265.7661.185.camel@chandra-lucid.beaverton.ibm.com>
	<20110510194023.GA25420@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110510194023.GA25420@us.ibm.com>
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

On Tue, May 10 2011 at  3:40pm -0400,
Malahal Naineni <malahal@us.ibm.com> wrote:

> Chandra Seetharaman [sekharan@us.ibm.com] wrote:
> > Create a new initramds by using the --preload option to mkinitrd.
> > 
> > Exact syntax can be found in section 5.1 of
> > http://sourceware.org/lvm2/wiki/MultipathUsageGuide
> 
> I don't that works in RHEL6. It seems to be a known issue in RHEL6.

A valid workaround should be to pass rdloaddriver=<drivername> on the kernel
commandline, e.g.: rdloaddriver=scsi_dh_emc
