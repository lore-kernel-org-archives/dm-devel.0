From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: git repo problem?
Date: Thu, 2 Jul 2009 12:58:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907021255380.1263@e-smith.charlieb.ott.istop.com>
References: <Pine.LNX.4.64.0906231512040.18393@e-smith.charlieb.ott.istop.com>
	<1245868230.26915.22.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0906241700480.22601@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0906241700480.22601@e-smith.charlieb.ott.istop.com>
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


On Wed, 24 Jun 2009, Charlie Brady wrote:

> On Wed, 24 Jun 2009, Chandra Seetharaman wrote:
>
>>  I see "SUN" "LCSM100_F" in hwtable.c Christophe's tree
>>  (http://git.kernel.org/?p=linux/storage/multipath-tools/.git)
>
> Does Christophe's repo have a problem?
>
> bash-3.2$ git-clone 
> http://git.kernel.org/?p=linux/storage/multipath-tools/.git
> Initialized empty Git repository in 
> /home/speech/bradyc/WIP/multipath-tools.upstream/multipath-tools/.git/
> Cannot get remote repository information.
> Perhaps git-update-server-info needs to be run there?
> bash-3.2$

I'm still having access problems, although the symptoms have changed:

bash-3.2$ git-clone http://kernel.org/pub/scm/linux/storage/multipath-tools/.git
Initialized empty Git repository in /home/speech/bradyc/WIP/multipath-tools.upstream/multipath-tools/.git/
got 14df6388e07bb09302e1e79b1744414b8a94974c
walk 14df6388e07bb09302e1e79b1744414b8a94974c
got be39fd4ecfce9593ec2f7c051e8d2f7bdaa6f3f0
got 8f0cb7332f468ac7a5f4456ee6076e9a872384ed
...
got 3b0e9929427d8edae611e64b9bf8e0edadea3f03
got a9a6c71592d4e2271a38c3d334bee7cbce963cff
walk a9a6c71592d4e2271a38c3d334bee7cbce963cff
got d4bfff0b7c4476b70b2267611ff16e53d36fc31f
fatal: Not a valid object name HEAD
bash-3.2$

Advice?
