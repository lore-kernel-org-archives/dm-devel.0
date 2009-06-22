From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: A simple, generic DM-API, for codecs/transcoders to
	use?
Date: Mon, 22 Jun 2009 11:08:49 -0400
Message-ID: <20090622150849.GA23765@mars.virtualiron.com>
References: <49C0B79A.9010601@googlemail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49C0B79A.9010601@googlemail.com>
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

On Wed, Mar 18, 2009 at 09:58:02AM +0100, Navid Zamani wrote:
> Hello DM mailing list.
> 
> I a have a simple question:
> Is there a way to use the device-mapper to hang an arbitrary program
> in-between a real block device, and the virtual device created by the
> device-mapper?
> Like with LUKS. Only that I do not want to compress or encrypt. I want
> to hang an error-correcting transcoder in between, so I can put ECC on
> any block device I want.
> The optimal thing would be a simple API, that is implemented in many
> languages. (Like FUSE is available in many languages.)
> Something like this would really be a powerful abstraction to have.
> 
> In case you are interested in the reasons: Modern consumer HDDs do not
> have any ECC, but they get less and less reliable. It went so far, that

I thought that the more recent patches by Oracle to support DIF/DIX (Data
Integrity Extensions):
http://oss.oracle.com/projects/data-integrity/dist/documentation/linux-hba.pdf

Are addressing this by adding a checksum for each block sector that is
checked by each device. So the firmware on the hard-drive, along with
the SAS controller would carry out the checksumming?
