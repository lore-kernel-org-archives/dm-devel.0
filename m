From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: blacklisted paths?
Date: Mon, 19 Sep 2005 16:07:18 -0700
Message-ID: <20050919230718.GA26508@us.ibm.com>
References: <20050919211649.GA24756@locust.cns.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050919211649.GA24756@locust.cns.vt.edu>
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

Ray Stell <stellr@cns.vt.edu> wrote:
> [root@pecan ~]# multipath  -v3 -d | grep blacklist
> dm-0 blacklisted
> dm-1 blacklisted
> dm-2 blacklisted
> dm-3 blacklisted
> dm-4 blacklisted
> dm-5 blacklisted
> fd0 blacklisted
> hda blacklisted
> hdb blacklisted
> hdc blacklisted
> md0 blacklisted
> ram0 blacklisted
> ram10 blacklisted
> ram11 blacklisted
> ram12 blacklisted
> ram13 blacklisted
> ram14 blacklisted
> ram15 blacklisted
> ram1 blacklisted
> ram2 blacklisted
> ram3 blacklisted
> ram4 blacklisted
> ram5 blacklisted
> ram6 blacklisted
> ram7 blacklisted
> ram8 blacklisted
> ram9 blacklisted
> sdf blacklisted
> sdh blacklisted
> sdm blacklisted

Well I do not have a good explanation why the blacklisting is not more
consistent, but can you send your /etc/multipath.conf. I might suspect
that a devnode_blacklist regular expression maybe matching resulting in
blacklisting when it should not.


-andmike
--
Michael Anderson
andmike@us.ibm.com
