From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Custom priority callout
Date: Wed, 13 Aug 2008 10:51:59 -0400
Message-ID: <20080813145159.GB17006@mars.virtualiron.com>
References: <A7519D7FDEF2A144BA6D40BDF13100FEF14CB5@ex2.Beer.Town>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <A7519D7FDEF2A144BA6D40BDF13100FEF14CB5@ex2.Beer.Town>
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

On Wed, Aug 13, 2008 at 09:32:27AM -0500, Jim Lester wrote:
> I know that the issue with writing custom priority callouts is that they
> need to be running in RAM so that if the disk is lost, it can be called
> again. 
> 
> My question is, if I write a custom binary file, and statically compile
> it so it doesn't link against any libraries, does multipath
> automatically load it into RAM because it mentioned in the config file,
> or is their other code that has to be modified to load it. 

It will most certainly be evicted from memory. You might be better of using
the more recent versions of multipath and making your custom priority callout
as one of the libraries in the 'libprio' directory. You will need to modify the Makefile
and the libprio.c to include your code. Keep in mind if you segfault in it
you will bring down multipathd with it.

Oh, and do post it on this mailing list so that multipath can nativly support
the Compellant path priority code (I thought it was multibus??)
