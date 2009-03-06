From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: multipath-tools with iSCSI
Date: Fri, 6 Mar 2009 11:07:47 -0500
Message-ID: <20090306160747.GI25755@mars.virtualiron.com>
References: <37F771A073BAAB4FB86D0EC80808C2840452DDC40E@BEN-EXC7-00.concat.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <37F771A073BAAB4FB86D0EC80808C2840452DDC40E@BEN-EXC7-00.concat.de>
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

On Fri, Mar 06, 2009 at 09:18:40AM +0100, Gustav Siegel wrote:
> Hi,
> 
> i have to connect iSCSI storage via multiple pathes on my Server.
> My question is, if I need some different settings for iSCSI instead to FC?

You shouldn't need to - mulitpathd handles iSCSI, FC, local disks, SAS SAN
the same way. Unless the storage in question isn't in the list
when you type multipathd -k'show config'. If the vendor/product regular
expressions don't match then you might need an entry in multipath.conf.

Most of the time vendors provide a User Guide explaining what needs
to be added to multipaht.conf
