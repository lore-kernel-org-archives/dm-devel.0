From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] libdevmapper: (4/6) Add filtering feature to
	dm_report
Date: Wed, 18 Apr 2007 12:47:40 -0400
Message-ID: <46264BAC.3000504@ce.jp.nec.com>
References: <46264A57.1020800@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070806050706080103000409"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46264A57.1020800@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------070806050706080103000409
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

This patch adds a filtering feature to dm_report.

  - Add dm_report_set_filter() API.
    By calling this, dm_report_object() omits rows which doesn't
    match the condition specified by the filter.

  - Fitlers can be composed with the following components:
      * Simple comparison of field value
          '==', '!=', '>', '>=', '<', '<='
          Strings should be quoted by either ' or ".
          Only decimal, non-negative integers are currently allowed.
      * Regular expression
          '=~', '!~'
          Regular expression can be quoted by '/', '|', '#', or any
          other characters.
      * Logical combinations of the expressions
          'and', 'or', '!', '(', ')'

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------070806050706080103000409
Content-Type: text/x-patch;
 name="libdm-report-add-filter.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libdm-report-add-filter.patch"

Add filtering feature to dm_report.

Filter is set by dm_report_set_filters()
---
 lib/.exported_symbols |    1 
 lib/libdevmapper.h    |    4 
 lib/libdm-report.c    |  783 +++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 781 insertions(+), 7 deletions(-)

Index: device-mapper.work/lib/.exported_symbols
===================================================================
--- device-mapper.work.orig/lib/.exported_symbols
+++ device-mapper.work/lib/.exported_symbols
@@ -127,5 +127,6 @@ dm_report_field_int32
 dm_report_field_uint32
 dm_report_field_uint64
 dm_report_field_set_value
+dm_report_set_filter
 dm_regex_create
 dm_regex_match
Index: device-mapper.work/lib/libdevmapper.h
===================================================================
--- device-mapper.work.orig/lib/libdevmapper.h
+++ device-mapper.work/lib/libdevmapper.h
@@ -688,6 +688,10 @@ int dm_report_object(struct dm_report *r
 int dm_report_output(struct dm_report *rh);
 void dm_report_free(struct dm_report *rh);
 
+/* Set filter */
+int dm_report_set_filter(struct dm_report *rh,
+			 const char *filter, uint32_t flags);
+
 /*
  * Report functions are provided for simple data types.
  * They take care of allocating copies of the data.
Index: device-mapper.work/lib/libdm-report.c
===================================================================
--- device-mapper.work.orig/lib/libdm-report.c
+++ device-mapper.work/lib/libdm-report.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (C) 2002-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2007 NEC Corporation
  *
  * This file is part of device-mapper userspace tools.
  * The code is based on LVM2 report function.
@@ -14,6 +15,7 @@
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <ctype.h>
 #include "libdevmapper.h"
 #include "list.h"
 #include "log.h"
@@ -24,6 +26,7 @@
 #define RH_SORT_REQUIRED	0x00000100
 #define RH_HEADINGS_PRINTED	0x00000200
 
+struct filter_node;
 struct dm_report {
 	struct dm_pool *mem;
 
@@ -46,6 +49,8 @@ struct dm_report {
 
 	/* To store caller private data */
 	void *private;
+
+	struct filter_node *filter_root;
 };
 
 /*
@@ -474,6 +479,653 @@ static int _parse_keys(struct dm_report 
 	return 1;
 }
 
+/*
+ * Filter tokens
+ */
+
+/*
+ * Comparison and logical operation tokens
+ *   OP_CMP := '==' | '!=' | '>' | '>=' | '<' | '<=' | '=~' | '!~'
+ *   OP_LOG := '!' | '(' | ')' | ',' | 'and' | 'or' | '&&' | '||'
+ */
+
+struct op_def {
+	const char *string;
+	uint32_t flags;
+	const char *desc;
+};
+
+static const char * _skip_space(const char *s)
+{
+	while (*s && isspace(*s))
+		s++;
+	return s;
+}
+
+static const char * _token_match(const char *s, const char *token)
+{
+	s = _skip_space(s);
+
+	if (!strncmp(s, token, strlen(token)))
+		return s + strlen(token);
+
+	return NULL;
+}
+
+static int _tok_op(struct op_def *t, const char *s, const char **end,
+		   uint32_t expect)
+{
+	const char *next;
+
+	for (; t->string; t++) {
+ 		if (expect && !(t->flags & expect))
+			continue;
+
+		if ((next = _token_match(s, t->string))) {
+			*end = next;
+			return t->flags;
+		}
+	}
+
+	*end = s;
+	return 0;
+}
+
+/* OP_CMP definition and matcher function */
+
+#define FLD_CMP_MASK	0x000FF000
+#define FLD_CMP_EQUAL	0x00001000
+#define FLD_CMP_NOT	0x00002000
+#define FLD_CMP_GT	0x00004000
+#define FLD_CMP_LT	0x00008000
+#define FLD_CMP_REGEX	0x00010000
+
+/* _tok_op() tries to match from the first of this list.
+ * So longer one should come first.
+ * e.g. ">=" should appear earlier in the list than ">". */
+static struct op_def _op_cmp[] = {
+	{ "==", FLD_CMP_EQUAL, "Equal to" },
+	{ "!=", FLD_CMP_NOT|FLD_CMP_EQUAL, "Not equal" },
+	{ ">=", FLD_CMP_GT|FLD_CMP_EQUAL|DM_REPORT_FIELD_TYPE_NUMBER,
+	  "Greater than or equal to" },
+	{ ">", FLD_CMP_GT|DM_REPORT_FIELD_TYPE_NUMBER, "Greater than" },
+	{ "<=", FLD_CMP_LT|FLD_CMP_EQUAL|DM_REPORT_FIELD_TYPE_NUMBER,
+	  "Lesser than or equal to" },
+	{ "<", FLD_CMP_LT|DM_REPORT_FIELD_TYPE_NUMBER, "Lesser than" },
+	{ "=~", FLD_CMP_REGEX|DM_REPORT_FIELD_TYPE_STRING,
+	  "Matching regular expression" },
+	{ "!~", FLD_CMP_REGEX|FLD_CMP_NOT|DM_REPORT_FIELD_TYPE_STRING,
+	  "Not matching regular expression" },
+	{ NULL, 0, NULL }
+};
+
+static uint32_t _tok_op_cmp(const char *s, const char **end)
+{
+	return _tok_op(_op_cmp, s, end, 0);
+}
+
+/* OP_LOG definitions and matcher functions */
+
+#define FILTER_TYPE_MASK	0x00FF
+#define FILTER_COND	0x0001
+#define FILTER_AND	0x0002
+#define FILTER_OR	0x0004
+#define FILTER_MODIFIER_MASK	0x0F00
+#define FILTER_NOT	0x0100
+#define FILTER_DELIMITER_MASK	0xF000
+#define FILTER_PS	0x1000
+#define FILTER_PE	0x2000
+
+static struct op_def _op_log[] = {
+	{ "&&",  FILTER_AND, NULL },
+	{ "and", FILTER_AND, NULL },
+	{ ",",   FILTER_AND, NULL },
+	{ "||",  FILTER_OR,  NULL },
+	{ "or",  FILTER_OR,  NULL },
+	{ "!",   FILTER_NOT, NULL },
+	{ "(",   FILTER_PS,  NULL },
+	{ ")",   FILTER_PE,  NULL },
+	{ NULL,  0, NULL},
+};
+
+static int _tok_op_log(const char *s, const char **end, uint32_t expect)
+{
+	return _tok_op(_op_log, s, end, expect);
+}
+
+/*
+ * Other tokens (FIELD, VALUE, STRING, NUMBER, REGEX)
+ *     FIELD := <strings of alphabet, number and '_'>
+ *     VALUE := NUMBER | STRING
+ *     REGEX := <strings quoted by any character>
+ *     NUMBER := <strings of [0-9]> (because sort_value is unsigned)
+ *     STRING := <strings quoted by '"' or '\''>
+ *
+ * _tok_* functions
+ *
+ *   Input:
+ *     s             - a pointer to the parsed string
+ *   Output:
+ *     begin         - a pointer to the beginning of the token
+ *     end           - a pointer to the end of the token + 1
+ *                     or undefined if return value is NULL
+ *     return value  - a starting point of the next parsing
+ *                     NULL if s doesn't match with token type
+ *                     (the parsing should be terminated)
+ */
+
+static const char * _tok_number(const char *s,
+			        const char **begin, const char **end)
+{
+	*begin = s;
+	while (*s && isdigit(*s))
+		s++;
+	*end = s;
+
+	return s;
+}
+
+static const char * _tok_string(const char *s,
+			        const char **begin, const char **end,
+			        const char endchar)
+{
+	*begin = s;
+	while (*s && *s != endchar)
+		s++;
+	*end = s;
+
+	return s;
+}
+
+static const char * _tok_regex(const char *s,
+			       const char **begin, const char **end,
+			       char *quote)
+{
+	s = _skip_space(s);
+
+	if (!*s) {
+		log_error("Regular expression expected");
+		return NULL;
+	}
+
+	switch (*s) {
+		case '(': *quote = ')'; break;
+		case '{': *quote = '}'; break;
+		case '[': *quote = ']'; break;
+		default:  *quote = *s;
+	}
+
+	s = _tok_string(s + 1, begin, end, *quote);
+	if (!*s) {
+		log_error("Missing end quote of regex");
+		return NULL;
+	}
+	s++;
+
+	return s;
+}
+
+static const char * _tok_value(const char *s,
+			       const char **begin, const char **end,
+			       char *quote)
+{
+	s = _skip_space(s);
+
+	if (*s == '"' || *s == '\'') { /* quoted string */
+		*quote = *s;
+		s = _tok_string(s + 1, begin, end, *quote);
+		if (!*s) {
+			log_error("Missing end quote of string");
+			return NULL;
+		}
+		s++;
+	} else { /* number */
+		*quote = 0;
+		s = _tok_number(s, begin, end);
+		if (*begin == *end) {
+			log_error("Empty value or unquoted string");
+			return NULL;
+		}
+	}
+
+	return s;
+}
+
+static int _field_name_char(const char c)
+{
+	return (isalnum(c) || c == '_' || c == '-');
+}
+
+static const char * _tok_field_name(const char *s,
+				    const char **begin, const char **end)
+{
+	s = _skip_space(s);
+
+	*begin = s;
+	while (*s && _field_name_char(*s))
+		s++;
+	*end = s;
+
+	if (*begin == *end)
+		return NULL;
+
+	return s;
+}
+
+static void _display_operators(void)
+{
+	int i;
+
+	log_print(" ");
+	log_print("Comparison operators");
+	log_print("--------------------");
+
+	for (i = 0; _op_cmp[i].string; i++)
+		log_print("  %-4s - %s%s%s", _op_cmp[i].string, _op_cmp[i].desc,
+			_op_cmp[i].flags & DM_REPORT_FIELD_TYPE_NUMBER ?
+				" (numeric field only)" : "",
+			_op_cmp[i].flags & DM_REPORT_FIELD_TYPE_STRING ?
+				" (string field only)" : "");
+
+	log_print(" ");
+	log_print("Comparison operands");
+	log_print("-------------------");
+	log_print("  numbers            - decimal, non-negative, integer only");
+	log_print("  strings            - characters quoted by ' or \"");
+	log_print("  regular expression - characters quoted by any character");
+
+	log_print(" ");
+	log_print("Combining comparison");
+	log_print("--------------------");
+	log_print("  and, &&  - logical AND");
+	log_print("  or, ||   - logical OR");
+	log_print("  ()       - grouping expressions");
+	log_print("  !        - logical NOT");
+}
+
+/*
+ * Filter components
+ */
+
+/* a comparison condition */
+struct field_filter {
+	struct field_properties *fp;
+	uint32_t flags; /* see _op_cmp[] */
+	union {
+		const char *string;
+		uint64_t number;
+		struct dm_regex *regex;
+	} v;
+};
+
+/* an expression: either comparison condition, and-clause or or-clause */
+struct filter_node {
+	uint32_t type; /* FILTER_* */
+	struct list list;
+	union {
+		struct field_filter * f; /* type is COND */
+		struct list l; /* type is AND or OR */
+	} e;
+};
+
+static struct field_filter *_create_field_filter(struct dm_report *rh,
+						 uint32_t field_num,
+						 const char *v, size_t len,
+						 uint32_t flags)
+{
+	struct field_properties *fp, *found = NULL;
+	struct field_filter *filter;
+	char *s;
+
+	list_iterate_items(fp, &rh->field_props) {
+		if (fp->field_num == field_num) {
+			found = fp;
+			break;
+		}
+	}
+
+	/* The field is neither used in display options nor sort keys. */
+	if (!found) {
+		if (!(found = _add_field(rh, field_num, FLD_HIDDEN)))
+			return NULL;
+	}
+
+	if (!(found->flags & flags & DM_REPORT_FIELD_TYPE_MASK)) {
+		log_error("dm_report: Incompatible comparison type");
+		return NULL;
+	}
+
+	/* set up filter */
+	if (!(filter = dm_pool_zalloc(rh->mem, sizeof(struct field_filter)))) {
+		log_error("dm_report: struct field_filter allocation failed");
+		return NULL;
+	}
+	filter->fp = found;
+	filter->flags = flags;
+
+	/* store comparison operand */
+	if (flags & FLD_CMP_REGEX) {
+		if (!(s = dm_malloc(len + 1))) {
+			log_error("dm_report: dm_malloc failed");
+			goto out_free_filter;
+		}
+		memcpy(s, v, len);
+		s[len] = '\0';
+
+		filter->v.regex = dm_regex_create(rh->mem,
+						  (const char **) &s, 1);
+		dm_free(s);
+		if (!filter->v.regex) {
+			log_error("dm_report: failed to create matcher");
+			goto out_free_filter;
+		}
+	} else {
+		if (!(s = dm_pool_alloc(rh->mem, len + 1))) {
+			log_error("dm_report: dm_pool_alloc failed");
+			goto out_free_filter;
+		}
+		memcpy(s, v, len);
+		s[len] = '\0';
+
+		if (flags & DM_REPORT_FIELD_TYPE_STRING) {
+				filter->v.string = s;
+		} else {
+			filter->v.number = strtoul(s, NULL, 0);
+			dm_pool_free(rh->mem, s);
+		}
+	}
+
+	return filter;
+
+  out_free_filter:
+	dm_pool_free(rh->mem, filter);
+	return NULL;
+}
+
+static struct field_filter * _filter_match(struct dm_report *rh,
+					   const char *field, size_t flen,
+					   const char *value, size_t vlen,
+					   uint32_t flags)
+{
+	uint32_t f;
+
+	if (!flen)
+		return NULL;
+
+	for (f = 0; rh->fields[f].report_fn; f++)
+		if (_is_same_field(rh->fields[f].id,
+				   field, flen, rh->field_prefix))
+			return _create_field_filter(rh, f, value, vlen, flags);
+
+	log_print("Undefined field name");
+	return NULL;
+}
+
+static struct filter_node * _alloc_filter_node(struct dm_pool *mem,
+					       uint32_t type)
+{
+	struct filter_node *n;
+
+	if (!(n = dm_pool_zalloc(mem, sizeof(struct filter_node)))) {
+		log_error("dm_report: struct filter_node allocation failed");
+		return NULL;
+	}
+
+	list_init(&n->list);
+
+	n->type = type;
+	if (!(type & FILTER_COND))
+		list_init(&n->e.l);
+	return n;
+}
+
+/*
+ * Filter parser
+ *
+ * _parse_* functions
+ *
+ *   Input:
+ *     s             - a pointer to the parsed string
+ *   Output:
+ *     next          - a pointer used for next _parse_*'s input,
+ *                     next == s if return value is NULL
+ *     return value  - a filter node pointer,
+ *                     NULL if s doesn't match
+ */
+
+/*
+ * CONDITION := FIELD_NAME OP_CMP STRING |
+ *              FIELD_NAME OP_CMP NUMBER  |
+ *              FIELD_NAME OP_REGEX REGEX
+ */
+static struct filter_node * _parse_condition(struct dm_report *rh,
+					     const char *s, const char **next)
+{
+	struct field_filter *f;
+	struct filter_node *n;
+	const char *ws, *we; /* field name */
+	const char *vs, *ve; /* value */
+	const char *last;
+	uint32_t flags;
+	char quote;
+
+	/* field name */
+	if (!(last = _tok_field_name(s, &ws, &we))) {
+		log_error("Expecting field name");
+		goto syntax_error;
+	}
+	if (!last) {
+		log_error("Missing operator after the field name");
+		goto syntax_error;
+	}
+
+	/* comparison operator */
+	if (!(flags = _tok_op_cmp(we, &last))) {
+		log_error("Unrecognized comparison operator: %s", s);
+		goto syntax_error;
+	}
+	if (!last) {
+		log_error("Missing value after operator");
+		goto syntax_error;
+	}
+
+	/* comparison value */
+	if (flags & FLD_CMP_REGEX) {
+		if (!(last = _tok_regex(last, &vs, &ve, &quote)))
+			goto syntax_error;
+	} else {
+		if (!(last = _tok_value(last, &vs, &ve, &quote)))
+			goto syntax_error;
+
+		if (quote) {
+			/* the token is strings */
+			if (flags & DM_REPORT_FIELD_TYPE_NUMBER) {
+				log_print("The operator requires number");
+				goto syntax_error;
+			}
+			flags |= DM_REPORT_FIELD_TYPE_STRING;
+		} else {
+			/* the token is number */
+			if (flags & DM_REPORT_FIELD_TYPE_STRING) {
+				log_print("The operator requires string");
+				goto syntax_error;
+			}
+			flags |= DM_REPORT_FIELD_TYPE_NUMBER;
+		}
+	}
+	*next = _skip_space(last);
+
+	/* store condition */
+	f = _filter_match(rh, ws, (size_t) (we - ws),
+			  vs, (size_t) (ve - vs), flags);
+	if (!f)
+		goto syntax_error;
+
+	if (!(n = _alloc_filter_node(rh->mem, FILTER_COND)))
+		return NULL;
+	n->e.f = f;
+	return n;
+
+  syntax_error:
+	log_error("Filter syntax error at %s", s);
+	*next = s;
+	return NULL;
+}
+
+/* EX := CONDITION | '!'? '(' EXPRESSION ')' */
+static struct filter_node * _parse_or_ex(struct dm_report *,
+					 const char *, const char **,
+					 struct filter_node *);
+
+static struct filter_node * _parse_ex(struct dm_report *rh,
+					 const char *s, const char **next)
+{
+	struct filter_node *n = NULL;
+	uint32_t t;
+	const char *tmp;
+
+	t = _tok_op_log(s, next, FILTER_NOT|FILTER_PS);
+	if (t == FILTER_NOT) {
+		/* '!' '(' EXPRESSION ')' */
+		if (!_tok_op_log(*next, &tmp, FILTER_PS)) {
+			log_error("Syntax error: '(' expected");
+			goto out_error;
+		}
+		if (!(n = _parse_or_ex(rh, tmp, next, NULL)))
+			goto out_error;
+		n->type |= FILTER_NOT;
+		if (!_tok_op_log(*next, &tmp, FILTER_PE)) {
+			log_error("Syntax error: ')' expected");
+			goto out_error;
+		}
+		*next = tmp;
+	} else if (t == FILTER_PS) {
+		/* '(' EXPRESSION ')' */
+		if (!(n = _parse_or_ex(rh, *next, &tmp, NULL)))
+			goto out_error;
+		if (!_tok_op_log(tmp, next, FILTER_PE)) {
+			log_error("Syntax error: ')' expected");
+			goto out_error;
+		}
+	} else if ((s = _skip_space(s))) {
+		/* CONDITION */
+		n = _parse_condition(rh, s, next);
+	} else {
+		n = NULL;
+		*next = s;
+	}
+
+	return n;
+
+  out_error:
+	*next = s;
+	return NULL;
+}
+
+/* AND_EXPRESSION := EX (AND_OP AND_EXPRSSION) */
+static struct filter_node * _parse_and_ex(struct dm_report *rh,
+					  const char *s, const char **next,
+					  struct filter_node *and_n)
+{
+	struct filter_node *n;
+	const char *tmp;
+
+	n = _parse_ex(rh, s, next);
+	if (!n)
+		goto out_error;
+
+	if (!_tok_op_log(*next, &tmp, FILTER_AND)) {
+		if (!and_n)
+			return n;
+		list_add(&and_n->e.l, &n->list);
+		return and_n;
+	}
+
+	if (!and_n) {
+		if (!(and_n = _alloc_filter_node(rh->mem, FILTER_AND)))
+			goto out_error;
+	}
+	list_add(&and_n->e.l, &n->list);
+
+	return _parse_and_ex(rh, tmp, next, and_n);
+
+  out_error:
+	*next = s;
+	return NULL;
+}
+
+/* OR_EXPRESSION := AND_EXPRESSION (OR_OP OR_EXPRESSION) */
+static struct filter_node * _parse_or_ex(struct dm_report *rh,
+					 const char *s, const char **next,
+					 struct filter_node *or_n)
+{
+	struct filter_node *n;
+	const char *tmp;
+
+	n = _parse_and_ex(rh, s, next, NULL);
+	if (!n)
+		goto out_error;
+
+	if (!_tok_op_log(*next, &tmp, FILTER_OR)) {
+		if (!or_n)
+			return n;
+		list_add(&or_n->e.l, &n->list);
+		return or_n;
+	}
+
+	if (!or_n) {
+		if (!(or_n = _alloc_filter_node(rh->mem, FILTER_OR)))
+			goto out_error;
+	}
+	list_add(&or_n->e.l, &n->list);
+
+	return _parse_or_ex(rh, tmp, next, or_n);
+
+  out_error:
+	*next = s;
+	return NULL;
+}
+
+
+int dm_report_set_filter(struct dm_report *rh, const char *string,
+			 uint32_t flags)
+{
+	const char *fin;
+	struct filter_node *root;
+
+	if (flags) {
+		log_error("dm_report_set_filter: flags not supported");
+		return 0;
+	}
+
+	if (rh->filter_root) {
+		log_error("dm_report_set_filter: filter already set");
+		return 0;
+	}
+
+	/* null string means no filter */
+	if (!string || !string[0])
+		return 1;
+
+	if (!(root = _alloc_filter_node(rh->mem, FILTER_OR)))
+		goto out_error;
+
+	if (!_parse_or_ex(rh, string, &fin, root) || *_skip_space(fin)) {
+		dm_pool_free(rh->mem, root);
+		goto out_error;
+	}
+
+	rh->filter_root = root;
+	return 1;
+
+  out_error:
+	_display_operators();
+	log_print(" ");
+	_display_fields(rh);
+	log_print(" ");
+	return 0;
+}
+
 struct dm_report *dm_report_init(uint32_t *report_types,
 				 const struct dm_report_object_type *types,
 				 const struct dm_report_field_type *fields,
@@ -551,6 +1203,65 @@ void dm_report_free(struct dm_report *rh
 /*
  * Create a row of data for an object
  */
+static int _cmp_field_number(uint64_t a, uint64_t b, uint32_t flags)
+{
+	switch (flags & FLD_CMP_MASK) {
+	case FLD_CMP_EQUAL:
+		return a == b;
+	case FLD_CMP_NOT|FLD_CMP_EQUAL:
+		return a != b;
+	case FLD_CMP_GT:
+		return a > b;
+	case FLD_CMP_GT|FLD_CMP_EQUAL:
+		return a >= b;
+	case FLD_CMP_LT:
+		return a < b;
+	case FLD_CMP_LT|FLD_CMP_EQUAL:
+		return a <= b;
+	default:
+		log_error("Unsupported comparison type for number");
+	}
+	return 0;
+}
+
+static int _cmp_field_string(const char *a, const char *b, uint32_t flags)
+{
+	switch (flags & FLD_CMP_MASK) {
+	case FLD_CMP_EQUAL:
+		return !strcmp(a, b);
+	case FLD_CMP_NOT|FLD_CMP_EQUAL:
+		return strcmp(a, b);
+	default:
+		log_error("Unsupported comparison type for string");
+	}
+	return 0;
+}
+
+static int _cmp_field_regex(const char *s, struct dm_regex *r, uint32_t flags)
+{
+	return (dm_regex_match(r, s) >= 0) ^ ((flags & FLD_CMP_NOT) != 0);
+}
+
+static int _compare_field(struct dm_report_field *field,
+			  struct field_filter *filter)
+{
+	if (!field->sort_value) {
+		log_error("dm_report: field without value: %d",
+			  field->props->field_num);
+		return 0;
+	}
+
+	if (filter->flags & FLD_CMP_REGEX)
+		return _cmp_field_regex((const char *) field->sort_value,
+					filter->v.regex, filter->flags);
+	else if (field->props->flags & DM_REPORT_FIELD_TYPE_NUMBER)
+		return _cmp_field_number(*(const uint64_t *)field->sort_value,
+					 filter->v.number, filter->flags);
+	else /* DM_REPORT_FIELD_TYPE_STRING */
+		return _cmp_field_string((const char *) field->sort_value,
+					 filter->v.string, filter->flags);
+}
+
 static void * _report_get_field_data(struct dm_report *rh,
 			      struct field_properties *fp, void *object)
 {
@@ -562,6 +1273,51 @@ static void * _report_get_field_data(str
 	return ret + rh->fields[fp->field_num].offset;
 }
 
+static int _filter(struct filter_node *n, struct list *fields)
+{
+	int r;
+	struct filter_node *f;
+	struct dm_report_field *field;
+
+	switch (n->type & FILTER_TYPE_MASK) {
+		case FILTER_COND:
+			r = 1;
+			list_iterate_items(field, fields) {
+				if (n->e.f->fp != field->props)
+					continue;
+				if (!_compare_field(field, n->e.f))
+					r = 0;
+			}
+			break;
+		case FILTER_OR:
+			r = 0;
+			list_iterate_items(f, &n->e.l)
+				if ((r |= _filter(f, fields)))
+					break;
+			break;
+		case FILTER_AND:
+			r = 1;
+			list_iterate_items(f, &n->e.l)
+				if (!(r &= _filter(f, fields)))
+					break;
+			break;
+		default:
+			log_error("Unsupported filter type");
+			return 0;
+	}
+
+	return (n->type & FILTER_NOT) ? !r : r;
+}
+
+/* the object is given as a list of "struct field"s */
+static int _filter_object(struct dm_report *rh, struct list *fields)
+{
+	if (!rh->filter_root)
+		return 1;
+
+	return _filter(rh->filter_root, fields);
+}
+
 int dm_report_object(struct dm_report *rh, void *object)
 {
 	struct field_properties *fp;
@@ -582,24 +1338,23 @@ int dm_report_object(struct dm_report *r
 			       rh->keys_count))) {
 		log_error("dm_report_object: "
 			  "row sort value structure allocation failed");
-		return 0;
+		goto out_free_row;
 	}
 
 	list_init(&row->fields);
-	list_add(&rh->rows, &row->list);
 
 	/* For each field to be displayed, call its report_fn */
 	list_iterate_items(fp, &rh->field_props) {
 		if (!(field = dm_pool_zalloc(rh->mem, sizeof(*field)))) {
 			log_error("dm_report_object: "
 				  "struct dm_report_field allocation failed");
-			return 0;
+			goto out_free_row;
 		}
 		field->props = fp;
 
 		data = _report_get_field_data(rh, fp, object);
 		if (!data)
-			return 0;
+			goto out_free_row;
 
 		if (!rh->fields[fp->field_num].report_fn(rh, rh->mem,
 							 field, data,
@@ -607,9 +1362,20 @@ int dm_report_object(struct dm_report *r
 			log_error("dm_report_object: "
 				  "report function failed for field %s",
 				  rh->fields[fp->field_num].id);
-			return 0;
+			goto out_free_row;
 		}
 
+		list_add(&row->fields, &field->list);
+	}
+
+	/* Check filter and decide whether to display or not */
+	if (!_filter_object(rh, &row->fields))
+		goto out_free_row;
+
+	list_add(&rh->rows, &row->list);
+
+	/* For the object to be displayed, udpate width and record sort value */
+	list_iterate_items(field, &row->fields) {
 		if ((strlen(field->report_string) > field->props->width))
 			field->props->width = strlen(field->report_string);
 
@@ -617,13 +1383,16 @@ int dm_report_object(struct dm_report *r
 		    (field->props->flags & FLD_SORT_KEY)) {
 			(*row->sort_fields)[field->props->sort_posn] = field;
 		}
-		list_add(&row->fields, &field->list);
 	}
 
 	if (!(rh->flags & DM_REPORT_OUTPUT_BUFFERED))
 		return dm_report_output(rh);
 
 	return 1;
+
+  out_free_row:
+	dm_pool_free(rh->mem, row);
+	return 0;
 }
 
 /*

--------------070806050706080103000409
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070806050706080103000409--
