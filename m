From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: Missing patches
Date: Thu, 23 Jun 2016 20:06:24 +0200
Message-ID: <649b7736-209c-68c5-ea2e-bd6017fcc28a@gmail.com>
References: <CABr-GncjECgjZp6aXEYLtn8UPu5pCFiw9asNaSWaZO4WGB+KVw@mail.gmail.com>
	<231be53b-9202-0232-5eb8-7763d33c82a8@gmail.com>
	<CABr-Gndm2Mm1wfrmviHLdcaz0_X9o+k062Ggf4rg6w=6PDOXaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gndm2Mm1wfrmviHLdcaz0_X9o+k062Ggf4rg6w=6PDOXaA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/20/2016 01:35 PM, Christophe Varoqui wrote:

> For "replace spaces with tabs in defaults.h" I was deferring, in doubt
> : seems to be a coding style issue. Is the tabbed format agreed on with
> other maintainers ?

Right now it's a mess:

$ sed -e 's/ /-space-/g' -e 's/\t/-tabulator-/g' libmultipath/defaults.h

#define-space-DEFAULT_UID_ATTRIBUTE-tabulator-"ID_SERIAL"
#define-space-DEFAULT_UDEVDIR-tabulator--tabulator-"/dev"
#define-space-DEFAULT_MULTIPATHDIR-tabulator-"/"-space-LIB_STRING-space-"/multipath"
#define-space-DEFAULT_SELECTOR-tabulator-"service-time-space-0"
#define-space-DEFAULT_ALIAS_PREFIX-tabulator-"mpath"
#define-space-DEFAULT_FEATURES-tabulator-"0"
#define-space-DEFAULT_HWHANDLER-tabulator-"0"
#define-space-DEFAULT_MINIO-tabulator--tabulator-1000
#define-space-DEFAULT_MINIO_RQ-tabulator-1
#define-space-DEFAULT_PGPOLICY-space--space--space--space--space--space--space-FAILOVER
#define-space-DEFAULT_FAILBACK-space--space--space--space--space--space--space--FAILBACK_MANUAL
#define-space-DEFAULT_RR_WEIGHT-space--space--space--space--space--space-RR_WEIGHT_NONE
#define-space-DEFAULT_NO_PATH_RETRY-space--space-NO_PATH_RETRY_UNDEF
#define-space-DEFAULT_VERBOSITY-tabulator-2
#define-space-DEFAULT_REASSIGN_MAPS-tabulator-0
#define-space-DEFAULT_FIND_MULTIPATHS-tabulator-0
#define-space-DEFAULT_FAST_IO_FAIL-tabulator-5
#define-space-DEFAULT_DEV_LOSS_TMO-space--space--space-600
#define-space-DEFAULT_RETAIN_HWHANDLER-space-RETAIN_HWHANDLER_OFF
#define-space-DEFAULT_DETECT_PRIO-space-DETECT_PRIO_OFF
#define-space-DEFAULT_DEFERRED_REMOVE-space-DEFERRED_REMOVE_OFF
#define-space-DEFAULT_DELAY_CHECKS-space-DELAY_CHECKS_OFF
#define-space-DEFAULT_UEVENT_STACKSIZE-space-256
#define-space-DEFAULT_RETRIGGER_DELAY-space-10
#define-space-DEFAULT_RETRIGGER_TRIES-space-3
#define-space-DEFAULT_UEV_WAIT_TIMEOUT-space-30

#define-space-DEFAULT_CHECKINT-tabulator-5
#define-space-MAX_CHECKINT(a)-tabulator--tabulator-(a-space-<<-space-2)

#define-space-MAX_DEV_LOSS_TMO-tabulator-0x7FFFFFFF
#define-space-DEFAULT_PIDFILE-tabulator--tabulator-"/"-space-RUN_DIR-space-"/multipathd.pid"
#define-space-DEFAULT_SOCKET-tabulator--tabulator-"/org/kernel/linux/storage/multipathd"
#define-space-DEFAULT_CONFIGFILE-tabulator-"/etc/multipath.conf"
#define-space-DEFAULT_BINDINGS_FILE-tabulator-"/etc/multipath/bindings"
#define-space-DEFAULT_WWIDS_FILE-tabulator-"/etc/multipath/wwids"
#define-space-DEFAULT_CONFIG_DIR-tabulator-"/etc/multipath/conf.d"

char-space-*-space-set_default-space-(char-space-*-space-str);

> I wouldn't want to go in a patch-revert loop over this ;)

With git it's easy: https://www.atlassian.com/git/tutorials/undoing-changes/
