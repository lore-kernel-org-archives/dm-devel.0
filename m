From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: fields in "dmsetup status"
Date: Tue, 8 Nov 2005 18:42:11 +0000
Message-ID: <20051108184211.GY26394@agk.surrey.redhat.com>
References: <1653.1131473664@www93.gmx.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1653.1131473664@www93.gmx.net>
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

On Tue, Nov 08, 2005 at 07:14:24PM +0100, gistolero@gmx.de wrote:
> I would like to know the meaning of the different "dmsetup status" fields:
> yellow: 0 314572800 multipath 1 0 0 3 1 E 0 1 0 8:64 A 0 E 0 1 0 8:176 F ...

 * Info output has the following format:
 * num_multipath_feature_args [multipath_feature_args]*
 * num_handler_status_args [handler_status_args]*
 * num_groups init_group_number
 *            [A|D|E num_ps_status_args [ps_status_args]*
 *             num_paths num_selector_args
 *             [path_dev A|F fail_count [selector_args]* ]+ ]+
 *

Path group:
  A - currently active (max 1 in this state)
  E - enabled (i.e. bypass flag not set)
  D - disabled (i.e. bypass flag set)

Alasdair
-- 
agk@redhat.com
