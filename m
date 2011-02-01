From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: multipath: change the DEFAULT_MINIO for the request
 based multipath
Date: Mon, 31 Jan 2011 22:13:16 -0500
Message-ID: <20110201031316.GA10957@redhat.com>
References: <20110120160726.GA23529@redhat.com>
	<4D392FBD.5080207@ce.jp.nec.com>
	<1295599627.23625.16.camel@zezette>
	<20110121141204.GE30411@redhat.com>
	<1295621193.23625.37.camel@zezette>
	<20110121173930.GB20278@us.ibm.com>
	<4D3E9020.6010009@ce.jp.nec.com> <20110126022307.GA512@us.ibm.com>
	<1296518031.6483.106.camel@zezette>
	<20110201022120.GA24297@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110201022120.GA24297@us.ibm.com>
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

On Mon, Jan 31 2011 at  9:21pm -0500,
Malahal Naineni <malahal@us.ibm.com> wrote:

> Christophe Varoqui [christophe.varoqui@gmail.com] wrote:
> > I pushed an implementation of the fully capable solution.
> > 
> > The behaviour is unchanged with dm-multipath <= 1.1.0
> > For newer driver, if no additional config is added to multipath.conf the
> > minio will be set to 1.
> > 
> > If Mike S. tests prove this value is not always optimal, it can be tuned
> > per device in hwtable (hwe->minio_rq) and overridden in multipath.conf
> > device{} and multipath{} section.
> > 
> > This seemed to be the most consistent behaviour, to me. But feel free to
> > disagree.
> > 
> > Please test carefully as the patch is quite invasive. I built and tested
> > lightly with a NetApp iSCSI simulator. The session produced the
> > following output
> 
> Where is the patch? I would like test it. I have a patch set that does
> what I said and was planning on adding a field to hwentry structure
> without adding a new config keyword in /etc/multipath.conf. It doesn't
> appear that big a change, but would like to see your patch.

Christophe committed it already, see the following multipath-tools
commit:
2b68b83 Support different 'minio' values for rq and bio based dm-multipath
