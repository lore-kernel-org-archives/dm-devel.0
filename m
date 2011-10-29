From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RHEL 6 I/O error messages during booting
Date: Fri, 28 Oct 2011 20:46:29 -0400
Message-ID: <20111029004628.GA29647@redhat.com>
References: <4EAB1B12.3080606@lanl.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4EAB1B12.3080606@lanl.gov>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Daniel Lang <langd@lanl.gov>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 28 2011 at  5:13pm -0400,
Daniel Lang <langd@lanl.gov> wrote:

> We are having an issue that appears to be related to fact that the
> scsi_dh_rdac module is loaded after the qla FC driver and  SAN paths
> coming up before rdac can handle them. How can we change the order
> of kernel modules so that the scsi_dh_rdac module is loaded before
> the FC driver?

Add 'rdloaddriver=scsi_dh_rdac' to the kernel commandline to have the
initramfs preload the module (scsi_dh_rdac.ko should already be in the
initramfs). 
